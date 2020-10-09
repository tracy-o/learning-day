Mox.defmock(BelfrageMock, for: Belfrage)
Mox.defmock(Belfrage.Clients.HTTPMock, for: Belfrage.Clients.HTTP)
Mox.defmock(Belfrage.Clients.LambdaMock, for: Belfrage.Clients.Lambda)
Mox.defmock(Belfrage.Clients.HTTP.MachineGunMock, for: Belfrage.Clients.HTTP.MachineGun)
Mox.defmock(Belfrage.AWS.STSMock, for: Belfrage.AWS.STS)
Mox.defmock(Belfrage.AWS.LambdaMock, for: Belfrage.AWS.Lambda)
Mox.defmock(Belfrage.AWSMock, for: Belfrage.AWS)
Mox.defmock(Belfrage.Helpers.FileIOMock, for: Belfrage.Helpers.FileIO)
Mox.defmock(Belfrage.XrayMock, for: Belfrage.Xray)
Mox.defmock(CacheStrategyMock, for: Belfrage.Behaviours.CacheStrategy)
Mox.defmock(CacheStrategyTwoMock, for: Belfrage.Behaviours.CacheStrategy)
Mox.defmock(Belfrage.Clients.CCPMock, for: Belfrage.Clients.CCP)
Mox.defmock(Belfrage.Dials.DialMock, for: Belfrage.Dial, skip_optional_callbacks: true)
Mox.defmock(Belfrage.Dials.DialMockWithOptionalCallback, for: Belfrage.Dial)
Mox.defmock(Belfrage.MonitorMock, for: Belfrage.Monitor)
