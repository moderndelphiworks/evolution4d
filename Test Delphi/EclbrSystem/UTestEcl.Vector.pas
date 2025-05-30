unit UTestEcl.Vector;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  StrUtils,
  Generics.Collections,
  ecl.std,
  ecl.vector;

type
  TVectorTest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestAdd;
    [Test]
    procedure TestInsert;
    [Test]
    procedure TestDelete;
    [Test]
    procedure TestRemove;
    [Test]
    procedure TestLength;
    [Test]
    procedure TestIsEmpty;
    [Test]
    procedure TestJoinStrings;
    [Test]
    procedure TestClear;
    [Test]
    procedure TestUnique;
    [Test]
    procedure TestContains;
    [Test]
    procedure TestIndexOf;
    [Test]
    procedure TestMerge;
    [Test]
    procedure TestFilter;
    [Test]
    procedure TestFirst;
    [Test]
    procedure TestLast;
    [Test]
    procedure TestAsType;
    [Test]
    procedure TestAsList;
    [Test]
    procedure TestToString;
    [Test]
    procedure TestEnumerator;
    [Test]
    procedure TestFormatCPF;
    [Test]
    procedure TestFactorialCalculation;
  end;

implementation

{ TArrayDataTest }

procedure TVectorTest.Setup;
begin

end;

procedure TVectorTest.TearDown;
begin

end;

procedure TVectorTest.TestAdd;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(3, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(20, LVector[1]);
  Assert.AreEqual(30, LVector[2]);
end;

procedure TVectorTest.TestInsert;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Insert(1, 15);
  LVector.Insert(3, 25);
  Assert.AreEqual(4, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(15, LVector[1]);
  Assert.AreEqual(20, LVector[2]);
  Assert.AreEqual(25, LVector[3]);
end;

procedure TVectorTest.TestDelete;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  LVector.Delete(1);
  Assert.AreEqual(2, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(30, LVector[1]);
end;

procedure TVectorTest.TestRemove;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  LVector.Remove(20);
  Assert.AreEqual(2, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(30, LVector[1]);
end;

procedure TVectorTest.TestLength;
var
  LVector: TVector<Integer>;
begin
  Assert.AreEqual(0, LVector.Length);
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(3, LVector.Length);
  LVector.Delete(1);
  Assert.AreEqual(2, LVector.Length);
end;

procedure TVectorTest.TestIsEmpty;
var
  LVector: TVector<Integer>;
begin
  Assert.IsTrue(LVector.IsEmpty);
  LVector.Add(10);
  Assert.IsFalse(LVector.IsEmpty);
  LVector.Delete(0);
  Assert.IsTrue(LVector.IsEmpty);
end;

procedure TVectorTest.TestJoinStrings;
var
  LVector: TVector<Integer>;
begin
  LVector.JoinStrings('10,20,30', ',');
  Assert.AreEqual(3, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(20, LVector[1]);
  Assert.AreEqual(30, LVector[2]);
end;

procedure TVectorTest.TestClear;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  LVector.Clear;
  Assert.AreEqual(0, LVector.Length);
end;

procedure TVectorTest.TestUnique;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(10);
  LVector.Add(30);
  LVector.Unique;
  Assert.AreEqual(3, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(20, LVector[1]);
  Assert.AreEqual(30, LVector[2]);
end;

procedure TVectorTest.TestContains;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.IsTrue(LVector.Contains(10));
  Assert.IsTrue(LVector.Contains(20));
  Assert.IsTrue(LVector.Contains(30));
  Assert.IsFalse(LVector.Contains(40));
end;

procedure TVectorTest.TestIndexOf;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(0, LVector.IndexOf(10));
  Assert.AreEqual(1, LVector.IndexOf(20));
  Assert.AreEqual(2, LVector.IndexOf(30));
  Assert.AreEqual(-1, LVector.IndexOf(40));
end;

procedure TVectorTest.TestMerge;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(3, LVector.Length);
  LVector.Merge([20, 30, 40, 50]);
  Assert.AreEqual(5, LVector.Length);
  Assert.AreEqual(10, LVector[0]);
  Assert.AreEqual(20, LVector[1]);
  Assert.AreEqual(30, LVector[2]);
  Assert.AreEqual(40, LVector[3]);
  Assert.AreEqual(50, LVector[4]);
end;

procedure TVectorTest.TestFactorialCalculation;
var
  LVector: TVector<Integer>;
  LFactorial: Integer;
begin
  // Arrange
  LVector := TVector<Integer>.Create([1, 2, 3, 4, 5, 6, 7]);
  // Act
  LFactorial := LVector.Reduce(function(Acc: Integer; Item: Integer): Integer
                               begin
                                 Result := Acc * Item;
                               end, 1);
  // Assert
  Assert.AreEqual(5040, LFactorial, 'Factorial calculation is incorrect.');
end;

procedure TVectorTest.TestFilter;
var
  LVector: TVector<Integer>;
  LArrayFiltered: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(33);
  LVector.Add(40);
  LVector.Add(53);
  LArrayFiltered := LVector.Filter(
    function(AValue: Integer): Boolean
    begin
      Result := AValue mod 2 = 0;
    end
  );
  Assert.AreEqual(3, LArrayFiltered.Length);
  Assert.AreEqual(10, LArrayFiltered[0]);
  Assert.AreEqual(20, LArrayFiltered[1]);
  Assert.AreEqual(40, LArrayFiltered[2]);
end;

procedure TVectorTest.TestFirst;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(10, LVector.First);
end;

procedure TVectorTest.TestFormatCPF;
var
  LNumbers: TVector<String>;
  LResult: Tuple;
begin
  LNumbers := TVector<String>.Create(TStd.Split('12345678900'));
  LResult := LNumbers.Filter(function(Value: String): Boolean
                             begin
                               Result := Pos(Value, '0123456789') > 0;
                             end)
                     .Filter(function(Value: String; Index: Integer): Boolean
                             begin
                               Result := Index <= 10;
                             end)
                     .Reduce(function(Arg1: String; Arg2: Tuple): Tuple
                             var
                               LPonto, LTraco, LCpf: String;
                             begin
                               LPonto := TStd.IfThen<String>((Arg2[1].AsType<Integer> = 3) or
                                                             (Arg2[1].AsType<Integer> = 6), '.', '');
                               LTraco := TStd.IfThen<String>((Arg2[1].AsType<Integer> = 9), '-', '');
                               LCpf := Arg2[0].AsType<String> + LPonto + LTraco + Arg1;

                               Result := [LCpf, Arg2[1].AsType<Integer> + 1];
                             end,
                             ['', 0]);

  Assert.AreEqual('123.456.789-00', LResult[0].AsType<String>);
end;

procedure TVectorTest.TestLast;
var
  LVector: TVector<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  Assert.AreEqual(30, LVector.Last);
end;

procedure TVectorTest.TestAsType;
var
  PTypeInfo: System.TypInfo.PTypeInfo;
  LVector: TVector<Integer>;
begin
  PTypeInfo := LVector.AsType;
  Assert.IsNotNull(PTypeInfo);
end;

procedure TVectorTest.TestAsList;
var
  LVector: TVector<Integer>;
  LList: TList<Integer>;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  LList := LVector.AsList;
  try
    Assert.IsNotNull(LList);
    Assert.AreEqual(LVector.Length, Integer(LList.Count));
    Assert.AreEqual(LVector[0], LList[0]);
    Assert.AreEqual(LVector[1], LList[1]);
    Assert.AreEqual(LVector[2], LList[2]);
  finally
    LList.Free;
  end;
end;

procedure TVectorTest.TestToString;
var
  LVector: TVector<Integer>;
  LStr: String;
begin
  LVector.Add(10);
  LVector.Add(20);
  LVector.Add(30);
  LStr := LVector.ToString;
  Assert.AreEqual('[10, 20, 30]', LStr);
end;

procedure TVectorTest.TestEnumerator;
var
  LVector: TVector<String>;
  Item: String;
  Last: String;
begin
  LVector.Add('One');
  LVector.Add('Two');
  LVector.Add('Three');
  for Item in LVector do
  begin
    Last := Item;
  end;
  Assert.AreEqual('Three', Last);
end;

initialization
  TDUnitX.RegisterTestFixture(TVectorTest);

end.



