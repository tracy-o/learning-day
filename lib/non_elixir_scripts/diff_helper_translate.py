#!/usr/bin/env python3

import asyncio
import json

class DiffHelper:
    def __init__(self, cosmos_api):
        global cosmos
        cosmos = cosmos_api

    async def get_release_for_env(self, cosmos_component, environment):
        def callback(e, response):
            if e:
                if e.status_code == 404:
                    raise Exception("Not an existing cosmos component")
                if e.status_code == 403:
                    raise Exception("Moz is not authorised to get deployment info from cosmos")
                else:
                    raise Exception(f"Could not get release for environment: {e.status_code}")
            return response['deployments'][0]['release']['version']

        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(None, lambda: cosmos.get_service_environment_deployments(cosmos_component, environment, callback))

    async def get_source_for_release(cosmos_component, release_version):
        async def cosmos_get_service_release(component, version):
            # This function should be implemented to interact with the actual service.
            # It should return a tuple (error, response) where error is None if no error occurred.
            pass

        try:
            error, response = await cosmos_get_service_release(cosmos_component, release_version)
            if error:
                if error.status_code == 403:
                    raise Exception("Moz is not authorised to get release info from cosmos")
                else:
                    raise Exception(f"Could not get release for environment: {error.status_code}")
            return response.source
        except Exception as e:
            raise e

    async def get_diff(self, cosmos_component):
        async def get_live_release_source():
            release_number = await self.get_release_for_env(cosmos_component, "live")
            return await self.get_source_for_release(cosmos_component, release_number)

        async def get_test_release_source():
            release_number = await self.get_release_for_env(cosmos_component, "test")
            return await self.get_source_for_release(cosmos_component, release_number)

        try:
            release_sources = await asyncio.gather(get_live_release_source(), get_test_release_source())
            repo_url = release_sources[0]['url'].replace('.git', '')
            return f"{repo_url}/compare/{release_sources[0]['revision']}...{release_sources[1]['revision']}"
        except Exception as err:
            return err

    async def get_latest_commits(self, cosmos_component, environment):
        try:
            release_number = await self.get_release_for_env(cosmos_component, environment)
            release_source = await self.get_source_for_release(cosmos_component, release_number)
            repo_url = release_source['url'].replace('.git', '')
            return f"{repo_url}/commits/{release_source['revision']}"
        except Exception as err:
            return err
        
    async def get_commits_for_user(self, cosmos_component, environment, github_user):
        try:
            commits_url = await self.get_latest_commits(cosmos_component, environment)
            return f"{commits_url}?author=#{github_user}"
        except Exception as err:
            return err
