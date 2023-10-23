.PHONY: lint test fetch_jwk download_bbc_error_pages build release install_cosmos_deploy
REGION = eu-west-1
BUILDPATH = /root/rpmbuild

none:
	@ echo Please specifiy a target

lint:
	MIX_ENV=test mix deps.get
	MIX_ENV=test mix format --check-formatted
	MIX_ENV=test mix credo

test:
	MIX_ENV=test mix test

smoke_test:
	MIX_ENV=dev mix deps.get
	@echo Running smoke tests for ${TARGET}
	
	if [ "${TARGET}" = "all" ]; then \
		set -o pipefail ; MIX_ENV=smoke_test mix smoke_test --raw-output .smoke_test_output --group-by spec | tee smoke_test_output.txt; \
    else \
		set -o pipefail ; MIX_ENV=smoke_test mix smoke_test --raw-output .smoke_test_output --group-by spec --only stack:${TARGET} | tee smoke_test_output.txt; \
    fi

fetch_jwk:
	$(eval JWK_FETCH_OUTPUT:=$(shell python3 ./jwk-fetcher.py test,live))
	@echo ${JWK_FETCH_OUTPUT} | grep -q 'success' || exit 1

download_bbc_error_pages:
	./download_bbc_error_pages.sh
	rpm -i bbc-error-pages.rpm

build:
	mix deps.get
	mix hex.audit
	mix distillery.release
	mkdir -p ${BUILDPATH}/SOURCES
	cp _build/prod/rel/belfrage/releases/*/belfrage.tar.gz ${BUILDPATH}/SOURCES/
	tar -zcf ${BUILDPATH}/SOURCES/bake-scripts.tar.gz bake-scripts/
	cp belfrage.spec ${BUILDPATH}/SOURCES/
	cp SOURCES/* ${BUILDPATH}/SOURCES/
	rpmbuild --define "_topdir ${BUILDPATH}" --define "version ${COSMOS_VERSION}" -ba belfrage.spec

release:
	for component in ${COMPONENTS}; do \
		echo $$component; \
		cp cosmos_config/$$component.json cosmos/release-configuration.json; \
		cosmos set-repositories $$component repositories.json; \
		cosmos-release service $$component --release-version=v ${BUILDPATH}/RPMS/x86_64/*.x86_64.rpm; \
	done; \

deploy:
	for component in ${COMPONENTS}; do \
		cosmos deploy $$component test --force --release ${COSMOS_VERSION}; \
		if [ "$$component" = "belfrage" ] && [ "${FORCE}" != "true" ]; then \
			cosmos deploy $$component live --force --release ${COSMOS_VERSION}; \
		fi; \
	done; \