unit UTestEvolution.Match;

interface

uses
  Rtti,
  SysUtils,
  Classes,
  Generics.Collections,
  System.Evolution.Match,
  System.Evolution.Tuple,
//  System.Evolution.Std,
  System.Evolution.ArrowFun,
  System.Evolution.ResultPair,
  DUnitX.TestFramework;

type
  TAnimal = class end;

  TDog = class(TAnimal)
  end;

  TProduct = class
    Name: String;
    Price: Double;
  end;

  TDiscount = class
    function CalculateDiscount(OriginalPrice: Double): Double; virtual; abstract;
  end;

  TPercentageDiscount = class(TDiscount)
    Percentage: Double;
    function CalculateDiscount(OriginalPrice: Double): Double; override;
  end;

  TFixedAmountDiscount = class(TDiscount)
    Amount: Double;
    function CalculateDiscount(OriginalPrice: Double): Double; override;
  end;

  TEnumType = (One, Two, Three);

  TMatchTypeA = class
    // Campos e m�todos espec�ficos para o padr�o A
  end;

  TMatchTypeA1 = class
    // Campos e m�todos espec�ficos para o padr�o A1
  end;

  TMatchTypeA2 = class
    // Campos e m�todos espec�ficos para o padr�o A2
  end;

  TDiaSemana = (Domingo, Segunda, Terca, Quarta, Quinta, Sexta, Sabado);
  TDiasSemanaSet = set of TDiaSemana;

  [TestFixture]
  TestTMatch = class
  private
    FValue1, FValue2: Integer;
    procedure Proc1;
    procedure Proc2;
    procedure ProcWithParam(Value: Integer);
  public
    [Setup]
    procedure Setup;
    [Teardown]
    procedure Teardown;
    [Test]
    procedure TestMatchWithMatchingCase;
    [Test]
    procedure TestMatchWithNoMatchingCase;
    [Test]
    procedure TestMatchWithMultipleCases;
    [Test]
    procedure TestSingleCaseOf;
    [Test]
    Procedure TestCaseEqArrayInteger;
    [Test]
    Procedure TestCaseEqArrayString;
    [Test]
    Procedure TestCaseEqArrayChar;
    [Test]
    procedure TestCaseArray;
    [Test]
    procedure TestSingleCaseOfWithArgument;
    [Test]
    procedure TestCaseMultiple;
    [Test]
    procedure TestRange;
    [Test]
    procedure TestCaseIfAndGuard;
    [Test]
    procedure TestCaseIfOrGuard;
    [Test]
    procedure TestCaseIfNotGuard;
    [Test]
    procedure TestCaseDefault;
    [Test]
    procedure TestCaseTryExcept;
    [Test]
    procedure TestCaseChar;
    [Test]
    procedure TestCaseRangeSet;
    [Test]
    procedure TestCaseRegex;
    [Test]
    procedure TestCaseIsMatching;
    [Test]
    procedure TestCaseIsObjectMatching;
    [Test]
    procedure TestPatternCombinator;
    [Test]
    procedure TestMultipleCombines;
    [Test]
    procedure TestEnumPatternMatching;
    [test]
    procedure TestEnumPatternMatchingWithReturn;
    [Test]
    procedure TestPatternMatchingWithProduct;
    [Test]
    procedure TestPatternMatchingWithDiscounts;
    [Test]
    procedure TestCaseGtWithInteger;
    [Test]
    procedure TestCaseLtWithInteger;
    [Test]
    procedure TestNestedCases;
    [Test]
    procedure TestCombineWithDefault;
    [Test]
    procedure TestDefaultExecutionFailure;
    [Test]
    procedure TestMatchWithTTuple;
    [Test]
    procedure TestMatchTupla;
    [Test]
    procedure TestMatchTupla_1;
    [Test]
    procedure TestMatchTupla_2;
    [Test]
    procedure TestMatchTupla_3;
    [Test]
    procedure TestMatchTupla_4;
    [Test]
    procedure TestMatchTupla_5;
    [Test]
    procedure TestMatchTuplaArrowFun;
    [Test]
    procedure TestMatchHttpStatus;
    [Test]
    procedure TestCaseWeekdaySet;
    [Test]
    procedure TestCaseRangeSetInteger;
end;

implementation

procedure TestTMatch.Setup;
begin
  FValue1 := 1;
  FValue2 := 2;
end;

procedure TestTMatch.Teardown;
begin

end;

procedure TestTMatch.Proc1;
begin
  FValue1 := 42;
end;

procedure TestTMatch.Proc2;
begin
  FValue2 := 42;
end;

procedure TestTMatch.ProcWithParam(Value: Integer);
begin
  FValue1 := Value * 10;
end;

procedure TestTMatch.TestCaseIfAndGuard;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
  LValue: Integer;
begin
  LValue := 1;
  LResult := TMatch<Integer>.Value(LValue)
                            .CaseIf((LValue > 0) and (0 < LValue))
                            .CaseEq(1, procedure
                                       begin
                                         LResultString := 'Matched 1 with AndGuard';
                                       end)
                            .Execute;
  Assert.AreEqual('Matched 1 with AndGuard', LResultString);
end;

procedure TestTMatch.TestCaseArray;
var
  LMatchResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
begin
  LIsMatch := False;
  LMatchResult := TMatch<Integer>.Value(2)
                                 .CaseIn([1, 2, 3], TArrow.Fn<Boolean>(LIsMatch, True))
                                 .CaseIn([1, 4, 8], TArrow.Fn<Boolean>(LIsMatch, False))
                                 .CaseIn([1, 9, 6], TArrow.Fn<Boolean>(LIsMatch, False))
                                 .Execute;
  Assert.IsTrue(LIsMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseEqArrayChar;
var
  LMatchResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
  LValue: TArray<Char>;
begin
  LIsMatch := False;
  LValue := ['E', 'V', 'N'];

  LMatchResult := TMatch<TArray<Char>>.Value(LValue)
                                  .CaseEq(['V', 'E', 'N'], TArrow.Fn<Boolean>(LIsMatch, False))
                                  .CaseEq(['E', 'V', 'N'], TArrow.Fn<Boolean>(LIsMatch, True))
                                  .CaseEq(['N', 'E', 'V'], TArrow.Fn<Boolean>(LIsMatch, False))
                                  .Default(TArrow.Fn<Boolean>(LIsMatch, False))
                                  .Execute;
  Assert.IsTrue(LIsMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseEqArrayInteger;
var
  LMatchResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
  LValue: TArray<Integer>;
begin
  LIsMatch := False;
  LValue := [1, 4, 8];

  LMatchResult := TMatch<TArray<Integer>>.Value(LValue)
                                  .CaseIf(1 in [2, 8, 1])
                                  .CaseIf(Length(LValue) > 2)
                                  .CaseEq([1, 2, 3], procedure begin LIsMatch := False; end)
                                  .CaseEq([1, 4, 8], procedure begin LIsMatch := True; end)
                                  .CaseEq([1, 9, 6], procedure begin LIsMatch := False; end)
                                  .CaseRegex('email@gmail.com', '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$')
                                  .Default(procedure begin LIsMatch := False; end)
                                  .Execute;
  Assert.IsTrue(LIsMatch, 'Expected match to be successful');
  Assert.IsTrue(LMatchResult.isSuccess, 'Expected match to be successful')
end;

procedure TestTMatch.TestCaseEqArrayString;
var
  LMatchResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
  LValue: TArray<String>;
begin
  LIsMatch := False;
  LValue := ['Eu', 'Voc�', 'N�s'];

  LMatchResult := TMatch<TArray<String>>.Value(LValue)
                                  .CaseEq(['Voc�', 'Eu', 'N�s'], procedure begin LIsMatch := False; end)
                                  .CaseEq(['Eu', 'Voc�', 'N�s'], procedure begin LIsMatch := True; end)
                                  .CaseEq(['N�s', 'Eu', 'Voc�'], procedure begin LIsMatch := False; end)
                                  .Execute;
  Assert.IsTrue(LIsMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseGtWithInteger;
var
  LValue: Integer;
  LResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
begin
  LValue := 10;
  LIsMatch := False;

  LResult := TMatch<Integer>.Value(LValue)
    .CaseGt(5, procedure
      begin
        LIsMatch := True;
        Assert.Pass('Value is greater than 5.');
      end)
    .CaseGt(15, procedure
      begin
        LIsMatch := False;
        Assert.Fail('Value is not greater than 15.');
      end)
    .Execute;

  Assert.IsTrue(LIsMatch, 'Pattern matching failed.');
  Assert.AreEqual('Value is greater than 5.', LResult.ValueFailure, 'Pattern matching failed.');
end;

procedure TestTMatch.TestCaseChar;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<Char>.Value('A')
                              .CaseIn(['A', 'B', 'C'], procedure begin isMatch := True; end)
                              .CaseIn(['B', 'C'], procedure begin isMatch := False; end)
                              .CaseIn(['C'], procedure begin isMatch := False; end)
                              .Execute;

  Assert.IsTrue(isMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseDefault;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<Integer>.Value(42)
                                 .CaseEq(1, procedure begin isMatch := False; end)
                                 .CaseEq(2, procedure begin isMatch := False; end)
                                 .Default(  procedure begin isMatch := True; end)
                                 .Execute;

  Assert.IsTrue(isMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestMatchWithMatchingCase;
var
  LResult: TResultPair<Boolean, String>;
begin
  LResult := TMatch<Integer>.Value(FValue1)
                            .CaseEq(1, Proc1)
                            .Execute;
  Assert.AreEqual(42, FValue1);
  Assert.AreEqual(2, FValue2);
end;

procedure TestTMatch.TestMatchWithNoMatchingCase;
var
  LMatchResult: TResultPair<Boolean, String>;
begin
  LMatchResult := TMatch<Integer>.Value(FValue2)
                                 .CaseEq(2, Proc2)
                                 .Execute;
  Assert.IsFalse(LMatchResult.isFailure, 'Expected match to be successful');
end;

procedure TestTMatch.TestMatchWithTTuple;
var
  LDados: TTuple<String>;
  LChave: String;
  LValor: String;
  LResult: TResultPair<Boolean, String>;
begin
  LDados := TTuple<String>.New(['Nome', 'Idade', 'Cidade'], ['Alice', '25', 'Nova York']);

  // Teste com a chave 'Idade'
  LChave := 'Idade';
  LResult := TMatch<String>.Value(LChave)
    .CaseEq('Nome', procedure(Key: String)
                    begin
                      LValor := LDados.Get<String>(Key);
                    end)
    .CaseEq('Idade', TArrow.Fn<String>(LValor,
                                       LDados.Get<String>(TMatch.Value<String>))) // <<<<<==========
    .CaseEq('Cidade', procedure(Key: String)
                      begin
                        LValor := LDados.Get<String>(Key);
                      end)
    .Default(procedure begin LValor := 'Chave n�o encontrada'; end)
    .Execute;
  Assert.AreEqual('25', LValor);
  Assert.IsTrue(LResult.isSuccess);
  Assert.IsFalse(LResult.isFailure);
end;

procedure TestTMatch.TestNestedCases;
var
  LResult: TResultPair<Boolean, String>;
  LPattern: TMatch<TObject>;
  LTypeA: TMatchTypeA;
begin
  LTypeA := TMatchTypeA.Create;
  try
    LPattern := TMatch<TObject>.Value(LTypeA);

    LResult := LPattern.CaseIs<TMatchTypeA>(procedure(PatternTypeA: TMatchTypeA)
      begin
        LPattern.CaseIs<TMatchTypeA1>(procedure(PatternTypeA1: TMatchTypeA1)
          begin
            Assert.Pass('Pattern A1 successfully matched.');
          end);
        LPattern.CaseIs<TMatchTypeA2>(procedure(PatternTypeA2: TMatchTypeA2)
          begin
            Assert.Pass('Pattern A2 successfully matched.');
          end);
      end)
      .Execute;
  finally
    LTypeA.Free;
  end;
end;

procedure TestTMatch.TestPatternMatchingWithDiscounts;
var
  LProduct: TProduct;
  LDiscount: TDiscount;
  LResult:  TResultPair<Boolean, String>;
begin
  LProduct := TProduct.Create;
  LProduct.Name := 'Sample Product';
  LProduct.Price := 100.0;

  LDiscount := TPercentageDiscount.Create;
  (LDiscount as TPercentageDiscount).Percentage := 10;

  try
    LResult := TMatch<TProduct>.Value(LProduct)
      .CaseIs<TPercentageDiscount>(procedure(Discount: TPercentageDiscount)
                                   var
                                     DiscountedPrice: Double;
                                   begin
                                     DiscountedPrice := LProduct.Price - (LProduct.Price * Discount.Percentage / 100);
                                     Assert.AreEqual(90.0, DiscountedPrice, 0.01, 'Percentage discount calculation incorrect.');
                                   end)
      .CaseIs<TFixedAmountDiscount>(procedure(Discount: TFixedAmountDiscount)
                                    var
                                      DiscountedPrice: Double;
                                    begin
                                      DiscountedPrice := LProduct.Price - Discount.Amount;
                                      Assert.AreEqual(80.0, DiscountedPrice, 0.01, 'Fixed amount discount calculation incorrect.');
                                    end)
      .Default(procedure
               begin
                 Assert.Fail('No matching case found.');
               end)
      .Execute;

    Assert.IsTrue(LResult.isSuccess, 'Pattern matching failed.');
  finally
    LProduct.Free;
    LDiscount.Free;
  end;
end;

procedure TestTMatch.TestPatternMatchingWithProduct;
var
  LProduct: TProduct;
  LDiscount: TDiscount;
  LResult:  TResultPair<Boolean, String>;
begin
  LProduct := TProduct.Create;
  LProduct.Name := 'Sample Product';
  LProduct.Price := 100.0;
  LDiscount := TPercentageDiscount.Create;
  try
    (LDiscount as TPercentageDiscount).Percentage := 10;

    LResult := TMatch<TProduct>.Value(LProduct)
      .CaseIs<TPercentageDiscount>(procedure(LDiscount: TPercentageDiscount)
                                   var
                                     LDiscountedPrice: Double;
                                   begin
                                     LDiscountedPrice := LProduct.Price - (LProduct.Price * LDiscount.Percentage / 100);
                                     Assert.AreEqual(90.0, LDiscountedPrice, 0.01, 'Percentage discount calculation incorrect.');
                                   end)
        .Default(procedure
                 begin
                   Assert.Fail('No matching case found.');
                 end)
        .Execute;

    Assert.IsTrue(LResult.isSuccess, 'Pattern matching failed.');
  finally
    LProduct.Free;
    LDiscount.Free;
  end;
end;

procedure TestTMatch.TestCaseMultiple;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
  LResultStringNot: String;
  LValues: Tuple;
begin
  LValues := ['Matched 1 or 2', 'Matched 3 not'];
  LResult := TMatch<Integer>.Value(2)
                            .CaseIn([1, 2], TArrow.Fn([@LResultString, @LResultStringNot],
                                                      LValues))
                            .Execute;
  Assert.AreEqual('Matched 1 or 2', LResultString);
  Assert.AreEqual('Matched 3 not', LResultStringNot);
end;

procedure TestTMatch.TestCaseIfNotGuard;
var
  LResultString: String;
  LValue: Integer;
  LResult: TResultPair<Boolean, String>;
begin
  LValue := 1;
  LResult := TMatch<Integer>.Value(LValue)
                            .CaseIf((LValue = 1) and not (LValue <> 1))
                            .CaseEq(1, TArrow.Fn<String>(LResultString, 'Matched 1 with NotGuard'))
                            .Execute;
  Assert.AreEqual('Matched 1 with NotGuard', LResultString);
end;

procedure TestTMatch.TestCaseIfOrGuard;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
  LValue: Integer;
begin
  LValue := 1;
  LResult := TMatch<Integer>.Value(LValue)
                            .CaseIf((LValue = 1) or (LValue < 0))
                            .CaseEq(1, procedure begin LResultString := 'Matched 1 with OrGuard'; end)
                            .Execute;
  Assert.AreEqual('Matched 1 with OrGuard', LResultString);
end;

procedure TestTMatch.TestRange;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
begin
  LResult := TMatch<Integer>.Value(5)
                   .CaseRange(1, 10, procedure begin LResultString := 'Matched range 1-10'; end)
                   .Execute;
  Assert.AreEqual('Matched range 1-10', LResultString);
end;

procedure TestTMatch.TestCaseRegex;
var
  LMatchResult: TResultPair<Boolean, String>;
begin
  LMatchResult := TMatch<Integer>.Value(2)
                                 .CaseIn([1, 2, 3], TArrow.Fn(True))
                                 .CaseIn([1, 4, 8], TArrow.Fn(False))
                                 .CaseIn([1, 9, 6], TArrow.Fn(False))
                                 .CaseRegex('email@gmail.com', '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$')
                                 .Execute;

  Assert.IsTrue(TArrow.Value<Boolean>, 'Expected match to be successful');
  Assert.IsTrue(LMatchResult.ValueSuccess, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseRangeSet;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<Char>.Value('A')
                              .CaseIn(['A'..'Z'], procedure
                                                  begin
                                                    isMatch := True;
                                                  end)
                              .CaseIn([1..10], procedure
                                                begin
                                                  isMatch := False;
                                                end)
                              .Execute;

  Assert.IsTrue(isMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseRangeSetInteger;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<Integer>.Value(1)
                              .CaseIn(['A'..'Z'], procedure
                                                  begin
                                                    isMatch := False;
                                                  end)
                              .CaseIn([1..10], procedure
                                                begin
                                                  isMatch := True;
                                                end)
                              .Execute;

  Assert.IsTrue(isMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestCaseWeekdaySet;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<TDiaSemana>.Value(Sabado)
                                    .CaseIn([Segunda, Terca, Quarta, Quinta, Sexta], procedure
                                                      begin
                                                        isMatch := True;
                                                      end)
                                    .CaseIn([Domingo, Sabado], procedure
                                                      begin
                                                        isMatch := False;
                                                      end)
                                    .Execute;

  Assert.IsFalse(isMatch, 'Expected match to be successful');
  Assert.IsTrue(LMatchResult.isSuccess, 'Expected match to be successful');
end;

procedure TestTMatch.TestSingleCaseOf;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
begin
  LResult := TMatch<Integer>.Value(1)
                            .CaseEq(1, TArrow.Fn<String>(LResultString, 'Matched 1'))
                            .Execute;
  Assert.AreEqual('Matched 1', LResultString);
end;

procedure TestTMatch.TestSingleCaseOfWithArgument;
var
  LResult: TResultPair<Boolean, String>;
  LResultString: String;
begin
  LResult := TMatch<Integer>.Value(1)
                            .CaseEq(1, procedure(Arg: Integer) begin LResultString := Format('Matched %d', [Arg]); end)
                            .Execute;
  Assert.AreEqual('Matched 1', LResultString);
end;

procedure TestTMatch.TestCaseTryExcept;
var
  LMatchResult: TResultPair<Boolean, String>;
  isMatch: Boolean;
begin
  isMatch := False;
  LMatchResult := TMatch<Integer>.Value(42)
                                 .CaseEq(1, procedure begin isMatch := False; end)
                                 .CaseEq(42, procedure begin raise Exception.Create('TryExcept'); end)
                                 .TryExcept(procedure begin isMatch := True; end)
                                 .Execute;

  Assert.AreEqual('TryExcept', LMatchResult.ValueFailure, 'Expected match to be successful');
  Assert.IsTrue(LMatchResult.isFailure, 'Expected match to be successful');
  Assert.IsTrue(isMatch, 'Expected match to be successful');
end;

procedure TestTMatch.TestEnumPatternMatching;
var
  LResult: TResultPair<Boolean, String>;
  EnumValue: TEnumType;
  ResultString: String;
begin
  EnumValue := TEnumType.Two;

  LResult := TMatch<TEnumType>.Value(EnumValue)
    .CaseEq(TEnumType.One, procedure
                           begin
                             ResultString := 'EnumValue is One';
                           end)
    .CaseEq(TEnumType.Two, procedure
                           begin
                             ResultString := 'EnumValue is Two';
                           end)
    .CaseEq(TEnumType.Three, procedure
                             begin
                               ResultString := 'EnumValue is Three';
                             end)
    .Default(procedure
             begin
               ResultString := 'EnumValue is not recognized';
             end)
    .Execute;

  Assert.AreEqual('EnumValue is Two', ResultString);
end;

procedure TestTMatch.TestEnumPatternMatchingWithReturn;
var
  LResult: TResultPair<String, String>;
  LEnumValue: TEnumType;
begin
  LEnumValue := TEnumType.Two;
  LResult := TMatch<TEnumType>.Value(LEnumValue)
    .CaseEq(TEnumType.One, function: TValue
                           begin
                             Result := 'EnumValue is One';
                           end)
    .CaseEq(TEnumType.Two, function: TValue
                           begin
                             Result := 'EnumValue is Two';
                           end)
    .CaseEq(TEnumType.Three, function: TValue
                             begin
                               Result := 'EnumValue is Three';
                             end)
    .Default(function: TValue
             begin
               Result := 'EnumValue is not recognized';
             end)
    .Execute<String>.When(
        procedure(Valeu: String)
        begin
          // Success (LResult.ValueSuccess)
        end,
        procedure(Value: String)
        begin
         // Failure (LResult.ValueFailure)
        end);

  Assert.AreEqual('EnumValue is Two', LResult.ValueSuccess);
end;

procedure TestTMatch.TestCaseIsMatching;
var
  LResult: TResultPair<Boolean, String>;
  LValueList: TArray<Integer>;
  ResultString: String;
begin
  LValueList := [42, 36];

  LResult := TMatch<Integer>.Value(LValueList[0])
                .CaseIs<Integer>(procedure(Value: Integer)
                                 begin
                                   ResultString := 'Value is an Integer: ' + Value.ToString;
                                 end)
                .CaseIs<String>(procedure(Value: String)
                                begin
                                  ResultString := 'Value is a String: ' + Value;
                                end)
                .CaseIs<TDateTime>(procedure(Value: TDateTime)
                                   begin
                                     ResultString := 'Value is a DateTime: ' + DateTimeToStr(Value);
                                   end)
                .Default(procedure
                         begin
                           ResultString := 'Value is of an unknown type';
                         end)
                .Execute;

  Assert.AreEqual('Value is an Integer: 42', ResultString);
end;

procedure TestTMatch.TestCaseIsObjectMatching;
var
  LResult: TResultPair<Boolean, String>;
  LValueList: TArray<TAnimal>;
  ResultString: String;
begin
  LValueList := [TDog.Create];
  try
    LResult := TMatch<TAnimal>.Value(LValueList[0])
      .CaseIs<Integer>(procedure(Value: Integer)
                       begin
                         ResultString := 'Value is an Integer: ' + Value.ToString;
                       end)
      .CaseIs<String>(procedure(Value: String)
                      begin
                        ResultString := 'Value is a String: ' + Value;
                      end)
      .CaseIs<TDateTime>(procedure(Value: TDateTime)
                         begin
                           ResultString := 'Value is a DateTime: ' + DateTimeToStr(Value);
                         end)
      .CaseIs<TAnimal>(procedure(Value: TAnimal)
                       begin
                         ResultString := 'Value is a Object: ' + Value.ClassName;
                       end)
      .Default(procedure
               begin
                 ResultString := 'Value is of an unknown type';
               end)
      .Execute;

    Assert.IsTrue(LResult.isSuccess);
    Assert.AreEqual('Value is a Object: TDog', ResultString);
  finally
    LValueList[0].Free;
  end;
end;

procedure TestTMatch.TestCaseLtWithInteger;
var
  LValue: Integer;
  LResult: TResultPair<Boolean, String>;
  LIsMatch: Boolean;
begin
  LValue := 10;
  LIsMatch := False;
  LResult := TMatch<Integer>.Value(LValue)
    .CaseLt(15, procedure
                begin
                  LIsMatch := True;
                  Assert.Fail('Value is not greater than 15.');
                end)
    .CaseLt(5, procedure
               begin
                 LIsMatch := False;
                 Assert.Pass('Value is greater than 5.');
               end)
    .Execute;

  Assert.IsTrue(LIsMatch, 'Pattern matching failed.');
  Assert.AreEqual('Value is not greater than 15.', LResult.ValueFailure, 'Pattern matching failed.');
end;

procedure TestTMatch.TestPatternCombinator;
var
  LResult: TResultPair<Boolean, String>;
  LValueString: String;
  LResultString: String;
  LStrPattern: TMatch<String>;
begin
  LValueString := 'Hello';
  LResultString := '';

  LStrPattern := TMatch<String>.Value(LValueString)
                                 .CaseIs<String>(
                                   procedure
                                   begin
                                     LResultString := 'Value is a String';
                                   end);

  LResult := TMatch<String>.Value(LValueString)
                .Combine(LStrPattern)
                .Default(procedure
                         begin
                           LResultString := 'Value is of an unknown type';
                         end)
                .Execute;
  Assert.AreEqual('Value is a String', LResultString);
end;

procedure TestTMatch.TestMultipleCombines;
var
  LValueString: String;
  LResultString: String;
  LStrPattern1: TMatch<String>;
  LStrPattern2: TMatch<String>;
  LResult: TResultPair<Boolean, String>;
begin
  LValueString := 'Hello';
  LResultString := '';

  LStrPattern1 := TMatch<String>.Value(LValueString)
                                .CaseIf(Length(LValueString) > 3)
                                .CaseIs<String>(procedure
                                        begin
                                          LResultString := LResultString + 'Type is a String ';
                                        end);
  LStrPattern2 := TMatch<String>.Value(LValueString)
                                .CaseEq('Hello', procedure
                                         begin
                                           LResultString := LResultString + 'Value is "Hello"';
                                         end);

  LResult := TMatch<String>.Value(LValueString)
    .Combine(LStrPattern1)
    .Combine(LStrPattern2)
    .Default(procedure
             begin
               LResultString := 'Value is of an unknown type';
             end)
    .Execute;

  Assert.AreEqual('Type is a String Value is "Hello"', LResultString);
end;

procedure TestTMatch.TestCombineWithDefault;
var
  LValueString: String;
  LResultString: String;
  LStrPattern1, LStrPattern2: TMatch<String>;
  LCombinedPattern: TResultPair<Boolean, String>;
begin
  LValueString := 'Hello';

  LStrPattern1 := TMatch<String>.Value(LValueString)
    .CaseIs<Integer>(procedure
                     begin
                       LResultString := 'Type is a String';
                     end);

  LStrPattern2 := TMatch<String>.Value(LValueString)
    .CaseEq('World', procedure
                     begin
                       LResultString := 'Value is "World"';
                     end);

  LCombinedPattern := TMatch<String>.Value(LValueString)
    .Combine(LStrPattern1)
    .Combine(LStrPattern2)
    .Default(procedure
             begin
               LResultString := 'Value is not matched by any pattern';
             end)
    .Execute;

  Assert.AreEqual('Value is not matched by any pattern', LResultString);
end;

procedure TestTMatch.TestDefaultExecutionFailure;
var
  LValue: Integer;
  LResult: TResultPair<Boolean, String>;
begin
  LValue := 100;

  LResult := TMatch<Integer>.Value(LValue)
    .CaseEq(42, procedure
                begin
                  // Caso correspondente
                end)
    .CaseLt(50, procedure
                begin
                  // Caso correspondente
                end)
    .Execute;

  Assert.IsFalse(LResult.isSuccess, 'Expected match to fail');
  Assert.IsTrue(LResult.isFailure, 'Expected match to fail');
end;

procedure TestTMatch.TestMatchWithMultipleCases;
var
  LResult: TResultPair<Boolean, String>;
begin
  LResult := TMatch<Integer>.Value(FValue1)
                            .CaseEq(1, ProcWithParam)
                            .CaseEq(2, Proc2)
                            .Execute;
  Assert.AreEqual(10, FValue1);
  Assert.AreEqual(2, FValue2);
end;

procedure TestTMatch.TestMatchHttpStatus;
var
  LMatchResult: TResultPair<String, String>;
  LStatus: Integer;
begin
  LStatus := 400;

//  Tradicional
//  LMatchResult := TMatch<Integer>.Value(LStatus)
//                     .CaseEq(200, function: TValue begin Result := 'OK'; end)
//                     .CaseEq(400, function: TValue begin Result := 'Bad request'; end)
//                     .CaseEq(404, function: TValue begin Result := 'Not found'; end)
//                     .CaseEq(418, function: TValue begin Result := 'I�m a teapot'; end)
//                     .Default(    function: TValue begin Result := 'Something�s wrong with the Internet'; end)
//                     .Execute<String>;

  // Com TArrow.Fn
  LMatchResult := TMatch<Integer>.Value(LStatus)
                       .CaseEq(200, TArrow.Result('Ok'))
                       .CaseEq(400, TArrow.Result('Bad request'))
                       .CaseEq(404, TArrow.Result('Not found'))
                       .CaseEq(418, TArrow.Result('I�m a teapot'))
                       .Default(    TArrow.Result('Something�s wrong with the Internet'))
                       .Execute<String>;

  Assert.IsTrue(LMatchResult.isSuccess, 'Expected match to be successful');
  Assert.AreEqual(LMatchResult.ValueSuccess, 'Bad request');
  Assert.AreEqual(TArrow.Value<String>, 'Bad request');
end;

procedure TestTMatch.TestMatchTupla;
var
  LTuple: Tuple;
  LResult: TResultPair<String, String>;
begin
  LTuple := ['Idade', 25];
  LResult := TMatch<Tuple>.Value(LTuple)
    .CaseEq(['_', 'Alice'], TArrow.Result('Personagem'))
    .CaseEq(['_', 25],      TArrow.Result('Jovem'))
    .CaseEq(['_', False],   function(Value: Tuple): TValue begin Result := 'Fria'; end)
    .Default(               function:               TValue begin Result := 'Default'; end)
    .Execute<String>;
  Assert.AreEqual('Jovem', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTuplaArrowFun;
var
  LResult: TResultPair<String, String>;
  function get_flag: String;
  begin
    Result := 'new';
  end;

  function get_init: String;
  begin
    Result := 'Result Init';
  end;

  function get_new: String;
  begin
    Result := 'Result New';
  end;

  function get_gen: String;
  begin
    Result := 'Result Gen';
  end;
begin
  LResult := TMatch<String>.Value(get_flag())
    .CaseEq('init', TArrow.Result(get_init()))
    .CaseEq('new',  TArrow.Result(get_new()))
    .CaseEq('gen',  TArrow.Result(get_gen()))
    .Default(TArrow.Result('Comando n�o encontrado!'))
    .Execute<String>;
  Assert.AreEqual('Result New', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTupla_1;
var
  LTuple: Tuple;
  LResult: TResultPair<String, String>;
begin
  LTuple := ['Idades', 'Idade', 25];
  LResult := TMatch<Tuple>.Value(LTuple)
    .CaseEq(['Nome', '_*'],         function(Value: Tuple): TValue begin Result := 'Personagem'; end)
    .CaseEq(['_*', 'Idade', '_*'],  function(Value: Tuple): TValue begin Result := 'Jovem'; end)
    .CaseEq(['Cidade', '_*'],       TArrow.Result('Fria'))
    .Default(                       function:               TValue begin Result := 'Default'; end)
    .Execute<String>;
  Assert.AreEqual('Jovem', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTupla_2;
var
  LTuple: Tuple;
  LResult: TResultPair<String, String>;
begin
  LTuple := ['Idade', 25, True];
  LResult := TMatch<Tuple>.Value(LTuple)
    .CaseEq(['_*', False], function(Value: Tuple): TValue begin Result := 'Personagem'; end)
    .CaseEq(['_*', True],  TArrow.Result('Jovem'))
    .CaseEq(['_*', False], function(Value: Tuple): TValue begin Result := 'Fria'; end)
    .Default(              function:               TValue begin Result := 'Default'; end)
    .Execute<String>;
  Assert.AreEqual('Jovem', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTupla_3;
var
  LTuple: Tuple;
  LResult: TResultPair<String, String>;
begin
  LTuple := ['Idade', 25, True];
  LResult := TMatch<Tuple>.Value(LTuple)
    .CaseEq(['_', '_', False], function(Value: Tuple): TValue begin Result := 'Personagem'; end)
    .CaseEq(['_', '_', True],  TArrow.Result('Jovem'))
    .CaseEq(['_', '_', False], function(Value: Tuple): TValue begin Result := 'Fria'; end)
    .Default(                  function:               TValue begin Result := 'Default'; end)
    .Execute<String>;
  Assert.AreEqual('Jovem', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTupla_4;
var
  LTuple: Tuple;
  LResult: TResultPair<String, String>;
begin
  LTuple := [1, 2, 3];
  LResult := TMatch<Tuple>.Value(LTuple)
    .CaseEq([0, '_', '_'], function(Value: Tuple): TValue begin Result := 'Personagem'; end)
    .CaseEq(['_', 2, '_'], TArrow.Result('Jovem'))
    .CaseEq([2, '_', '_'], function(Value: Tuple): TValue begin Result := 'Fria'; end)
    .Default(              function:               TValue begin Result := 'Default'; end)
    .Execute<String>;
  Assert.AreEqual('Jovem', LResult.ValueSuccess);
end;

procedure TestTMatch.TestMatchTupla_5;
var
  LResult: TResultPair<Boolean, String>;

  function get_flag(const AFlag: String): Boolean;
  begin
    Result := AFlag = 'templates';
  end;
begin
  LResult := TMatch<Tuple>.Value([get_flag('information'),
                                  get_flag('templates'),
                                  get_flag('pattern')])
    .CaseEq([True, '_', '_'], function(Value: Tuple): TValue
                              begin
                                // execute();
                                Result := True;
                              end)
    .CaseEq(['_', True, '_'], function(Value: Tuple): TValue
                              begin
                                // execute();
                                Result := True;
                              end)
    .CaseEq(['_', '_', True], function(Value: Tuple): TValue
                              begin
                                // execute();
                                Result := True;
                              end)
   .Default(TArrow.Result(False))
   .Execute<Boolean>;
  Assert.IsTrue(LResult.ValueSuccess);
end;

function TPercentageDiscount.CalculateDiscount(OriginalPrice: Double): Double;
begin
  Result := OriginalPrice * Percentage / 100;
end;

function TFixedAmountDiscount.CalculateDiscount(OriginalPrice: Double): Double;
begin
  Result := Amount;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMatch);

end.

