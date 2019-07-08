Mox.defmock(BelfrageMock, for: Belfrage)
Mox.defmock(Belfrage.Clients.HTTPMock, for: Belfrage.Clients.HTTP)
Mox.defmock(Belfrage.Clients.LambdaMock, for: Belfrage.Clients.Lambda)
ExUnit.start(trace: true)
