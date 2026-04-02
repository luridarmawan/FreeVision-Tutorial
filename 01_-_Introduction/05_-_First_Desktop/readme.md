# 01 - Introduction
## 05 - First Desktop

![image.png](image.png)

Minimal Free-Vision application

---
Program name, as is common with Pascal.

```pascal
program Project1;
```

For Free-Vision to be possible at all, the **App** unit must be included.

```pascal
uses
  App;   // TApplication
```

Declaration for the Free-Vision application.

```pascal
var
  MyApp: TApplication;
```

The three steps are always necessary for processing.

```pascal
begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Process
  MyApp.Done;   // Free
end.
```
