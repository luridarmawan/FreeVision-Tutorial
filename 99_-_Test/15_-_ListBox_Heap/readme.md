# 99 - Test
## 15 - ListBox Heap

![image.png](image.png)

In this example it is shown how to modify components at runtime.
A button is used for this, the label of which increases with each click.
Create new window. Windows are usually not opened modally, as you usually want to open several of them.

```pascal
  procedure TMyApp.NewWindows(Titel: ShortString);
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, Titel, wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```


---
**Unit with the new dialog.**
<br>
The dialog with the counter button.

```pascal
unit MyDialog;

```

If you want to modify a component at runtime, you have to declare it, otherwise you can no longer access it.
Directly with **Insert(New(...** no longer works.

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

In the constructor you can see that you take the detour via **CounterButton**.
**CounterButton** is needed for the modification.

```pascal
const
  cmTag = 1000;  // Local event constant

```

In the event handler, the number in the button is increased when pressed.
This shows why you need the **CounterButton**, without it you would have no access to **Title**.
Important, when you change a component, you have to redraw the component with **Draw**, otherwise you won't see the changed value.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
        end;
        cmTag: begin
          // Read focused entry
          // And output
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
