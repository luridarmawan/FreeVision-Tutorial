# 15 - Ready-made Dialogs
## 10 - Simple MessageBox with Preset Rect

![image.png](image.png)

With the MessageBox, you can also set the size manually.
For this you have to use **MessageBoxRect(...)**.

---
Here the size of the box is set manually with **R.Assign**.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          R.Assign(10, 3, 28, 20);  // Size of the box
          MessageBoxRect(R, 'Ich bin eine vorgegebene Box', nil, mfInformation + mfOkButton);
        end;
```
