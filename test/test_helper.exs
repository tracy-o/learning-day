Mox.defmock(IngressMock, for: Ingress)
Mox.defmock(Ingress.Clients.HTTPMock, for: Ingress.Clients.HTTP)
Mox.defmock(Ingress.Clients.LambdaMock, for: Ingress.Clients.Lambda)
ExUnit.start(trace: true)
