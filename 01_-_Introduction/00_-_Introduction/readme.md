# 01 - Introduction
## 00 - Introduction

**Free Vision** is the free variant of Turbo-Vision, which came with Turbo-Pascal.
Many think that FV is something outdated from the DOS era.
For normal desktop applications, this is true.
But there are applications where this is still very practical nowadays.
A very good example is with a **Telnet** access.
Or on a server that has no graphical interface.

Which Linux geek hasn't already struggled with **vi** or **nemo**.
If Linux had an FV editor on board, life would be much easier. ;-)

For this reason, I am currently dealing with **Free Vision**.
I learned a lot from the FV sources, and I also found something on an old diskette from a Turbo-Pascal book.
You can also find one thing or another on the Internet.
Since I want to share my experience, I am creating this tutorial.

I hope the whole thing is understandable, although it certainly has many spelling errors. :-D

If someone has suggestions and sees errors, they can share their criticism in the German Lazarus Forum. ;-)
<a href="">http://www.lazarusforum.de/viewtopic.php?f=22&t=11063&p=98205&hilit=freevision#p98205</a>

The sources for the tutorial can all be downloaded from the main page.
It is a zip file.

---
**Notes on the code:**

Free Vision uses codepage 437.
For this reason, for error-free display of umlauts, they should be used as char constants.

```pascal
ä = #132  Ä = #142
ö = #148  Ö = #153
ü = #129  Ü = #154
```


**General Note:**
If you want to change texts at runtime, e.g. **Label**, **StaticText**, be careful.
Since the texts are saved as **PString**, make sure to reserve enough memory for the texts in the constructor (Init).
The easiest way to do this is as follows, so there is enough space left for **world**.

```pascal
  StaticText := new(PStaticText, Init(Rect, 'Hallo           '));
  StaticText^.Text^ := 'Hello world';
```


**TListBox**
Be careful with the **TListBox** component, the **TList** you assign here must be cleaned up yourself in a **Destructor**.
Examples can be found in the chapter **Lists and ListBoxen**.

**General Note 64Bit:**
With 64Bit code, there can be errors, <s>this mainly concerns functions that use **FormatStr**.</s>
You can see this clearly with the line and column display of the windows.

**Turbo-Vision**
In this tutorial there are things that are **not** 100% compatible with **Turbo-Vision**.
Certain components and functions were only introduced with **Free-Vision** by **FPC**.
This includes **TabSheet** for example.
There are also functions that only exist in Turbo-Vision.
