# 99 - Test
## 10 - ListBox

![image.png](image.png)

In this example it is shown how to modify components at runtime.
A button is used for this, the label of which increases with each click.

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
  PMyDialog = ^TMyDialog;

  TMyDialog = object(TDialog)
  const
    cmTag = 1000;
  var
    ListBox: PListBox;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

In the constructor you can see that you take the detour via **CounterButton**.
**CounterButton** is needed for the modification.

```pascal
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  StringCollection: PCollection;

begin
  R.Assign(10, 5, 67, 17);
  inherited Init(R, 'ListBox Demo');

  Title := NewStr('dfsfdsa');

  // ListBox
  R.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  StringCollection := new(PCollection, Init(0, 1));
  StringCollection^.Insert(NewStr('Montag'));
  StringCollection^.Insert(NewStr('Dienstag'));
  StringCollection^.Insert(NewStr('Mittwoch'));
  StringCollection^.Insert(NewStr('Donnerstag'));
  StringCollection^.Insert(NewStr('Freitag'));
  StringCollection^.Insert(NewStr('Samstag'));
  StringCollection^.Insert(NewStr('Sonntag'));

  R.Assign(5, 2, 31, 7);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);

  Insert(ListBox);
  ListBox^.Insert(NewStr('aaaaaaaaa'));

  ListBox^.List^.Insert(NewStr('bbbbbbb'));
  ListBox^.SetRange(ListBox^.List^.Count);



  // Cancel-Button
  R.Assign(19, 9, 32, 10);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Ok-Button
  R.Assign(7, 9, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

In the event handler, the number in the button is increased when pressed.
This shows why you need the **CounterButton**, without it you would have no access to **Title**.
Important, when you change a component, you have to redraw the component with **Draw**, otherwise you won't see the changed value.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: string;

begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmTag: begin
          str(ListBox^.Focused + 1, s);
          MessageBox('Wochentag: ' + s + ' selected', nil, mfOKButton);
          ClearEvent(Event);   // End event.
        end;
      end;
    end;
  end;

end;

```
