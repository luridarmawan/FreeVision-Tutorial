# 06 - Lists and ListBoxen
## 00 - StringCollection Unsorted

![image.png](image.png)

If the string list should remain unsorted, use **PUnSortedStrCollection**.
Just **PCollection** is **not** enough, as this crashes on **Dispose**.

---

---
**Unit with the new dialog.**
<br>
The dialog with the UnSortedStrCollection.
Declaration of the dialog, nothing special.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

```

An UnSortedStrCollection is built and
as a demonstration its content is written to a StaticText.

```pascal
constructor TMyDialog.Init;
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PUnSortedStrCollection;

const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  R.Assign(10, 5, 50, 19);
  inherited Init(R, 'StringCollection Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
  s := '';

  for i := 0 to StringCollection^.Count - 1 do begin
    s := s + PString(StringCollection^.At(i))^ + #13;
  end;

  Dispose(StringCollection, Done); // Free the list

  R.Assign(5, 2, 36, 12);
  Insert(new(PStaticText, Init(R, s)));

  // Ok-Button
  R.Assign(5, 11, 18, 13);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```
