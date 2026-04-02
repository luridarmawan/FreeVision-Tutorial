# 02 - Status Line and Menu
## 30 - Menu Hints

![image.png](image.png)

Hints in the status line of the menu items.

---
Constants of the individual hints.
It's best to use the hcxxx names.

```pascal
const
  cmList   = 1002;  // File List
  cmAbout  = 1001;  // Show About

  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
```

The hint line must be inherited.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcFile, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),

      NewSubMenu('~O~ptionen', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~itor', '', kbNoKey, cmAbout, hcEdit, nil))),

      NewSubMenu('~H~ilfe', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))))));
  end;
```
