Mox.defmock(IngressMock, for: Ingress)
Mox.defmock(Ingress.Services.ServiceMock, for: Ingress.Behaviours.Service)
Mox.defmock(Ingress.HTTPClientMock, for: Ingress.HTTPClient)
ExUnit.start(trace: true)
