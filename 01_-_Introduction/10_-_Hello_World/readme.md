# 01 - Introduction
## 10 - Hello World

![image.png](image.png)

A Hello World with Free-Vision.
The text is output in a message box.

---

```pascal
program Project1;

uses
  App, MsgBox;
var
  MyApp: TApplication;

begin
  MyApp.Init;
  MessageBox('Hello World !', nil, mfOKButton);
  // MyApp.Run;   // If it should continue.
  MyApp.Done;
end.
```
