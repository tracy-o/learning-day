Mox.defmock(IngressMock, for: Ingress)
Mox.defmock(Ingress.Services.ServiceMock, for: Ingress.Behaviours.Service)
ExUnit.start(trace: true)
