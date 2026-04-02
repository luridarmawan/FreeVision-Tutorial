# 06 - Lists and ListBoxen
## 30 - ListBox Double-Click

![image.png](image.png)

If you want to evaluate a double-click on a **ListBox**, you have to inherit the ListBox and insert a new handle event.

---

---
**Unit with the new dialog.**
<br>
The dialog with the ListBox

```pascal
unit MyDialog;

```

Inheriting the ListBox.
Since I'm inheriting anyway, I also added the **destructor**, which cleans up the list at the end.

```pascal
type

  PNewListBox = ^TNewListBox;

  { TNewListBox }

  TNewListBox = object(TListBox)
    destructor Done; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PNewListBox;
    StringCollection: PUnSortedStrCollection;
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

The new **HandleEvent** of the new ListBox, which intercepts the double-click and interprets it as [Ok].

```pascal
procedure TNewListBox.HandleEvent(var Event: TEvent);
begin
  if (Event.What = evMouseDown) and (Event.double) then begin
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
end;

```

Manually free the memory of the list.

```pascal
destructor TNewListBox.Done;
begin
  Dispose(List, Done); // Free the list
  inherited Done;
end;

```

The event handler of the dialog.
Here simply an [Ok] is processed on the double-click.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        // On double-click on the ListBox or on clicking [Ok].
        cmOK: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
        end;
        cmTag: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
          // End event.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

```
