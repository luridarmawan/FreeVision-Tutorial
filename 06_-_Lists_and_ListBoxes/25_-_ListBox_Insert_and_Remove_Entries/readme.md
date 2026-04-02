# 06 - Lists and ListBoxen
## 25 - ListBox Insert and Remove Entries

![image.png](image.png)

With **ListBox** you can also insert, remove entries, etc.
Partly you have to access the list directly.

---

---
**Unit with the new dialog.**
<br>
The dialog with the multi-column ListBox

```pascal
unit MyDialog;

```

Declare the **destructor** which frees the **memory** of the list.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;

    constructor Init;
    destructor Done; virtual;  // Because of memory leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Generate components for the dialog.

```pascal
const
  cmMonat = 1000;  // Local event constant
  cmNewFocus = 1001;
  cmNewBack = 1002;
  cmDelete = 1003;

constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: integer;
const
  Tage: array [0..11] of shortstring = (
    'Januar', 'Februar', 'M' + #132'rz', 'April', 'Mai', 'Juni', 'Juli',
    'August', 'September', 'Oktober', 'November', 'Dezember');

begin
  R.Assign(10, 3, 64, 20);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // ScrollBar for ListBox
  R.Assign(22, 2, 23, 16);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

  // Month-Button
  R.A.X := R.B.X + 5;
  R.B.X := R.A.X + 14;
  R.A.Y := 2;
  R.B.Y := R.A.Y + 2;
  Insert(new(PButton, Init(R, '~M~onat', cmMonat, bfNormal)));

  // New button at focused entry
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~N~eu fokus', cmNewFocus, bfNormal)));

  // New-Button at end of list
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~N~eu hinten', cmNewBack, bfNormal)));

  // Remove
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~E~ntfernen', cmDelete, bfNormal)));

  // Cancel-Button
  R.Move(0, 3);
  Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));

  // Ok-Button
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Manually free the memory of the list.

```pascal
destructor TMyDialog.Done;
begin
  Dispose(ListBox^.List, Done); // Free the list
  inherited Done;
end;

```

The event handler
Here you can see how to insert and remove entries.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // do something
        end;
        cmNewFocus: begin
          // Inserts a new entry at the marked entry
          ListBox^.List^.AtInsert(ListBox^.Focused, NewStr('neu'));
          ListBox^.SetRange(ListBox^.List^.Count);
          ListBox^.Draw;
        end;
        cmNewBack: begin
          // Inserts a new entry at the end
          ListBox^.Insert(NewStr('neu'));
          ListBox^.Draw;
        end;
        cmDelete: begin
          // Deletes the focused entry
          ListBox^.FreeItem(ListBox^.Focused);
          ListBox^.Draw;
        end;
        cmMonat: begin
          // Output entry with focus
          if ListBox^.List^.Count > 0 then begin
            MessageBox('Monat: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
          end;
          // End event.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

```
