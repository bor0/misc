Program AoC;

Uses
  Sysutils;

Type
  StringArray = Array of String;

Function CountChars(Inputs : StringArray; I : Integer; Element : Char): Integer;

Var
  J, Count : Integer;

Begin
  Count := 0;
  For J := 0 To Length(Inputs) - 1 Do
  Begin
    If (Inputs[J][I+1] = Element) Then Count := Count + 1;
  End;

  CountChars := Count;
End;

Function GetOnlyChars(Inputs : StringArray; I : Integer; Element : Char): StringArray;

Var
  J, Count : Integer;
  Arr : StringArray;

Begin
  Count := 0;
  For J := 0 To Length(Inputs) - 1 Do
  Begin
    If (Inputs[J][I+1] = Element) Then
    Begin
      Setlength(Arr, Count + 1);
      Arr[Count] := Inputs[J];
      Count := Count + 1;
    End;
  End;

  GetOnlyChars := Arr;
end;

Function GetOxygen(Inputs : StringArray): String;
Var
  Inputs2 : StringArray;
  I, Ones, Zeros : Integer;
Begin
  Inputs2 := Inputs;

  I := 0;
  While Length(Inputs) <> 1 Do
  Begin
    Ones := CountChars(Inputs, I, '1');
    Zeros := CountChars(Inputs, I, '0');

    If (Ones >= Zeros)
    Then Inputs2 := GetOnlyChars(Inputs, I, '1')
    Else Inputs2 := GetOnlyChars(Inputs, I, '0');

    Inputs := Inputs2;
    I := I + 1;
  End;

  GetOxygen := Inputs2[0];
End;

Function GetCO2(Inputs : StringArray): String;
Var
  Inputs2 : StringArray;
  I, Ones, Zeros : Integer;
Begin
  Inputs2 := Inputs;

  I := 0;
  While Length(Inputs) <> 1 Do
  Begin
    Ones := CountChars(Inputs, I, '1');
    Zeros := CountChars(Inputs, I, '0');

    If (Ones < Zeros)
    Then Inputs2 := GetOnlyChars(Inputs, I, '1')
    Else Inputs2 := GetOnlyChars(Inputs, I, '0');

    Inputs := Inputs2;
    I := I + 1;
  End;

  GetCO2 := Inputs2[0];
End;

Var
  UserFile : Text;
  FileName, TFile : String;
  Inputs : StringArray;
  InputLength : Integer;
Begin
  FileName := 'input';
  Assign(UserFile, FileName);
  Reset(UserFile);
  InputLength := 0;
  Repeat
    Setlength(Inputs, InputLength + 1);
    Readln(UserFile,TFile);
    Inputs[InputLength] := TFile;
    InputLength := InputLength + 1;
  Until Eof(UserFile);
  Close(UserFile);

  Writeln(StrToInt( '%' + GetOxygen(Inputs)) * StrToInt( '%' + GetCO2(Inputs)));
End.
