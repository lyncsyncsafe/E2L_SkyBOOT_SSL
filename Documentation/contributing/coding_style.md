# Coding Style

This document describes the preferred C coding style for the
coreboot project. It is in many ways exactly the same as the Linux
kernel coding style. In fact, most of this document has been copied from
the [Linux kernel coding style](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/process/4.Coding.rst)

The guidelines in this file should be seen as a strong suggestion, and
should overrule personal preference. They may be ignored in individual
instances when there are good practical reasons to do so, and reviewers
are in agreement.

Any style questions that are not mentioned in here should be decided
between the author and reviewers on a case-by-case basis. When modifying
existing files, authors should try to match the prevalent style in that
file -- otherwise, they should generally match similar existing files in
coreboot.

Bulk style changes to existing code ("cleanup patches") should avoid
changing existing style choices unless they actually violate this style
guide, or there is broad consensus that the new version is an
improvement. By default the style choices of the original author should
be honored. (Note that `checkpatch.pl` is not part of this style guide,
and neither is `clang-format`. These tools can be useful to find
potential issues or simplify formatting in new submissions, but they
were not designed to directly match this guide and may have false
positives. They should not be bulk-applied to change existing code
except in cases where they directly match the style guide.)

## Indentation

Tabs are 8 characters, and thus indentations are also 8 characters.
There are heretic movements that try to make indentations 4 (or even 2!)
characters deep, and that is akin to trying to define the value of PI to
be 3.

Rationale: The whole idea behind indentation is to clearly define where
a block of control starts and ends. Especially when you've been looking
at your screen for 20 straight hours, you'll find it a lot easier to
see how the indentation works if you have large indentations.

Now, some people will claim that having 8-character indentations makes
the code move too far to the right, and makes it hard to read on a
80-character terminal screen. The answer to that is that if you need
more than 3 levels of indentation, you're screwed anyway, and should
fix your program.  Note that coreboot has expanded the 80 character
limit to 96 characters to allow for modern wider screens.

In short, 8-char indents make things easier to read, and have the added
benefit of warning you when you're nesting your functions too deep.
Heed that warning.

The preferred way to ease multiple indentation levels in a switch
statement is to align the "switch" and its subordinate "case" labels
in the same column instead of "double-indenting" the "case" labels.
E.g.:

```c
switch (suffix) {
case 'G':
case 'g':
	mem <<= 30;
	break;
case 'M':
case 'm':
	mem <<= 20;
	break;
case 'K':
case 'k':
	mem <<= 10;
	__fallthrough;
default:
	break;
}
```

Don't put multiple statements on a single line unless you have
something to hide:

```c
if (condition) do_this;
  do_something_everytime;
```

Don't put multiple assignments on a single line either. Kernel coding
style is super simple. Avoid tricky expressions.

Outside of comments, documentation and except in Kconfig, spaces are
never used for indentation, and the above example is deliberately
broken.

Get a decent editor and don't leave whitespace at the end of lines. This
will actually keep the patch from being tested in the CI, so patches
with ending whitespace cannot be merged.

## Breaking long lines and strings

Coding style is all about readability and maintainability using commonly
available tools.

The limit on the length of lines is 96 columns and this is a strongly
preferred limit.

Statements longer than 96 columns will be broken into sensible chunks,
unless exceeding 96 columns significantly increases readability and does
not hide information. Descendants are always substantially shorter than
the parent and are placed substantially to the right. The same applies
to function headers with a long argument list. However, never break
user-visible strings such as printk messages, because that breaks the
ability to grep for them.

## Placing Braces and Spaces

The other issue that always comes up in C styling is the placement of
braces. Unlike the indent size, there are few technical reasons to
choose one placement strategy over the other, but the preferred way, as
shown to us by the prophets Kernighan and Ritchie, is to put the opening
brace last on the line, and put the closing brace first, thusly:

```c
if (x is true) {
	we do y
}
```

This applies to all non-function statement blocks (if, switch, for,
while, do). E.g.:

```c
switch (action) {
case KOBJ_ADD:
	return "add";
case KOBJ_REMOVE:
	return "remove";
case KOBJ_CHANGE:
	return "change";
default:
	return NULL;
}
```

However, there is one special case, namely functions: they have the
opening brace at the beginning of the next line, thus:

```c
int function(int x)
{
	body of function
}
```

Heretic people all over the world have claimed that this inconsistency
is ... well ... inconsistent, but all right-thinking people know that
(a) K&R are _right_ and (b) K&R are right. Besides, functions are
special anyway (you can't nest them in C).

Note that the closing brace is empty on a line of its own, _except_ in
the cases where it is followed by a continuation of the same statement,
ie a "while" in a do-statement or an "else" in an if-statement, like
this:

```c
do {
	body of do-loop
} while (condition);
```

and

```c
if (x == y) {
	..
} else if (x > y) {
	...
} else {
	....
}
```

Rationale: K&R.

Also, note that this brace-placement also minimizes the number of empty
(or almost empty) lines, without any loss of readability. Thus, as the
supply of new-lines on your screen is not a renewable resource (think
25-line terminal screens here), you have more empty lines to put
comments on.

Do not unnecessarily use braces where a single statement will do.

```c
if (condition)
	action();
```

and

```c
if (condition)
	do_this();
else
	do_that();
```

This does not apply if only one branch of a conditional statement is a
single statement; in the latter case use braces in both branches:

```c
if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}
```

### Spaces

Linux kernel style for use of spaces depends (mostly) on
function-versus-keyword usage. Use a space after (most) keywords. The
notable exceptions are sizeof, typeof, alignof, and __attribute__,
which look somewhat like functions (and are usually used with
parentheses in Linux, although they are not required in the language, as
in: "sizeof info" after "struct fileinfo info;" is declared).

So use a space after these keywords:

```
if, switch, case, for, do, while
```

but not with sizeof, typeof, alignof, or __attribute__. E.g.,

```c
s = sizeof(struct file);
```

Do not add spaces around (inside) parenthesized expressions. This
example is

-   bad*:

```c
s = sizeof( struct file );
```

When declaring pointer data or a function that returns a pointer type,
the preferred use of '*' is adjacent to the data name or function
name and not adjacent to the type name. Examples:

```c
char *linux_banner;
unsigned long long memparse(char *ptr, char **retptr);
char *match_strdup(substring_t *s);
```

Use one space around (on each side of) most binary and ternary
operators, such as any of these:

```
=  +  -  <  >  *  /  %  |  &  ^  <=  >=  ==  !=  ?  :
```

but no space after unary operators:

```
&  *  +  -  ~  !  sizeof  typeof  alignof  __attribute__  defined
```

no space before the postfix increment & decrement unary operators:

```
++  --
```

no space after the prefix increment & decrement unary operators:

```
++  --
```

and no space around the '.' and "->" structure member operators.

Do not leave trailing whitespace at the ends of lines. Some editors with
"smart" indentation will insert whitespace at the beginning of new
lines as appropriate, so you can start typing the next line of code
right away. However, some such editors do not remove the whitespace if
you end up not putting a line of code there, such as if you leave a
blank line. As a result, you end up with lines containing trailing
whitespace.

Git will warn you about patches that introduce trailing whitespace, and
can optionally strip the trailing whitespace for you; however, if
applying a series of patches, this may make later patches in the series
fail by changing their context lines.

### Naming

C is a Spartan language, and so should your naming be. Unlike Modula-2
and Pascal programmers, C programmers do not use cute names like
ThisVariableIsATemporaryCounter. A C programmer would call that variable
"tmp", which is much easier to write, and not the least more difficult
to understand.

HOWEVER, while mixed-case names are frowned upon, descriptive names for
global variables are a must. To call a global function "foo" is a
shooting offense.

GLOBAL variables (to be used only if you _really_ need them) need to
have descriptive names, as do global functions. If you have a function
that counts the number of active users, you should call that
"count_active_users()" or similar, you should _not_ call it
"cntusr()".

Encoding the type of a function into the name (so-called Hungarian
notation) is brain damaged - the compiler knows the types anyway and can
check those, and it only confuses the programmer. No wonder MicroSoft
makes buggy programs.

LOCAL variable names should be short, and to the point. If you have some
random integer loop counter, it should probably be called "i". Calling
it "loop_counter" is non-productive, if there is no chance of it
being mis-understood. Similarly, "tmp" can be just about any type of
variable that is used to hold a temporary value.

If you are afraid to mix up your local variable names, you have another
problem, which is called the function-growth-hormone-imbalance syndrome.
See chapter 6 (Functions).

## Typedefs

Please don't use things like "vps_t".

It's a _mistake_ to use typedef for structures and pointers. When you
see a

```c
vps_t a;
```

in the source, what does it mean?

In contrast, if it says

```c
struct virtual_container *a;
```

you can actually tell what "a" is.

Lots of people think that typedefs "help readability". Not so. They
are useful only for:

(a) totally opaque objects (where the typedef is actively used to
_hide_ what the object is).

Example: "pte_t" etc. opaque objects that you can only access using
the proper accessor functions.

NOTE! Opaqueness and "accessor functions" are not good in themselves.
The reason we have them for things like pte_t etc. is that there really
is absolutely _zero_ portably accessible information there.

(b) Clear integer types, where the abstraction _helps_ avoid confusion
whether it is "int" or "long".

u8/u16/u32 are perfectly fine typedefs, although they fit into category
(d) better than here.

NOTE! Again - there needs to be a _reason_ for this. If something is
"unsigned long", then there's no reason to do

```c
typedef unsigned long myflags_t;
```

but if there is a clear reason for why it under certain circumstances
might be an "unsigned int" and under other configurations might be
"unsigned long", then by all means go ahead and use a typedef.

(c) when you use sparse to literally create a _new_ type for
type-checking.

(d) New types which are identical to standard C99 types, in certain
exceptional circumstances.

Although it would only take a short amount of time for the eyes and
brain to become accustomed to the standard types like 'uint32_t',
some people object to their use anyway.

Therefore, the Linux-specific 'u8/u16/u32/u64' types and their signed
equivalents which are identical to standard types are permitted --
although they are not mandatory in new code of your own.

When editing existing code which already uses one or the other set of
types, you should conform to the existing choices in that code.

(e) Types safe for use in userspace.

In certain structures which are visible to userspace, we cannot require
C99 types and cannot use the 'u32' form above. Thus, we use __u32
and similar types in all structures which are shared with userspace.

Maybe there are other cases too, but the rule should basically be to
NEVER EVER use a typedef unless you can clearly match one of those
rules.

In general, a pointer, or a struct that has elements that can reasonably
be directly accessed should _never_ be a typedef.

## Functions

Functions should be short and sweet, and do just one thing. They should
fit on one or two screenfuls of text (the ISO/ANSI screen size is 80x24,
as we all know), and do one thing and do that well.

The maximum length of a function is inversely proportional to the
complexity and indentation level of that function. So, if you have a
conceptually simple function that is just one long (but simple)
case-statement, where you have to do lots of small things for a lot of
different cases, it's OK to have a longer function.

However, if you have a complex function, and you suspect that a
less-than-gifted first-year high-school student might not even
understand what the function is all about, you should adhere to the
maximum limits all the more closely. Use helper functions with
descriptive names (you can ask the compiler to in-line them if you think
it's performance-critical, and it will probably do a better job of it
than you would have done).

Another measure of the function is the number of local variables. They
shouldn't exceed 5-10, or you're doing something wrong. Re-think the
function, and split it into smaller pieces. A human brain can generally
easily keep track of about 7 different things, anything more and it gets
confused. You know you're brilliant, but maybe you'd like to
understand what you did 2 weeks from now.

In source files, separate functions with one blank line. If the function
is exported, the EXPORT* macro for it should follow immediately after
the closing function brace line. E.g.:

```c
int system_is_up(void)
{
	return system_state == SYSTEM_RUNNING;
}
EXPORT_SYMBOL(system_is_up);
```

In function prototypes, include parameter names with their data types.
Although this is not required by the C language, it is preferred in
Linux because it is a simple way to add valuable information for the
reader.

## Centralized exiting of functions

Albeit deprecated by some people, the equivalent of the goto statement
is used frequently by compilers in form of the unconditional jump
instruction.

The goto statement comes in handy when a function exits from multiple
locations and some common work such as cleanup has to be done. If there
is no cleanup needed then just return directly.

The rationale is:

-   unconditional statements are easier to understand and follow
-   nesting is reduced
-   errors by not updating individual exit points when making
    modifications are prevented
-   saves the compiler work to optimize redundant code away ;)

```c
int fun(int a)
{
	int result = 0;
	char *buffer = kmalloc(SIZE);

	if (buffer == NULL)
		return -ENOMEM;

	if (condition1) {
		while (loop1) {
			...
		}
		result = 1;
		goto out;
	}
	...
	out:
	kfree(buffer);
	return result;
}
```

## Commenting

Comments are good, but there is also a danger of over-commenting. NEVER
try to explain HOW your code works in a comment: it's much better to
write the code so that the _working_ is obvious, and it's a waste of
time to explain badly written code.

Generally, you want your comments to tell WHAT your code does, not HOW.
Also, try to avoid putting comments inside a function body: if the
function is so complex that you need to separately comment parts of it,
you should probably go back to chapter 6 for a while. You can make small
comments to note or warn about something particularly clever (or ugly),
but try to avoid excess. Instead, put the comments at the head of the
function, telling people what it does, and possibly WHY it does it.

coreboot style for comments is the C89 "/* ... */" style. You may also
use C99-style "// ..." comments for single-line comments.

The preferred style for *short* (multi-line) comments is:

```c
/* This is the preferred style for short multi-line
   comments in the coreboot source code.
   Please use it consistently. */
```

The preferred style for *long* (multi-line) comments is:

```c
/*
 * This is the preferred style for long multi-line
 * comments in the coreboot source code.
 * Please use it consistently.
 *
 * Description:  A column of asterisks on the left side,
 * with beginning and ending almost-blank lines.
 */
```

It's also important to comment data, whether they are basic types or
derived types. To this end, use just one data declaration per line (no
commas for multiple data declarations). This leaves you room for a small
comment on each item, explaining its use.

## You've made a mess of it
That's OK, we all do. You've probably been told by your long-time Unix user
helper that "GNU emacs" automatically formats the C sources for you, and
you've noticed that yes, it does do that, but the defaults it uses are less
than desirable (in fact, they are worse than random typing - an infinite
number of monkeys typing into GNU emacs would never make a good program).

So, you can either get rid of GNU emacs, or change it to use saner values.
To do the latter, you can stick the following in your .emacs file:

```lisp
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/src/linux-trees")
                                        filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))
```

This will make emacs go better with the kernel coding style for C files
below ~/src/linux-trees.  Obviously, this should be updated to match
your own paths for coreboot.

But even if you fail in getting emacs to do sane formatting, not
everything is lost: use "indent".

Now, again, GNU indent has the same brain-dead settings that GNU emacs
has, which is why you need to give it a few command line options.
However, that's not too bad, because even the makers of GNU indent
recognize the authority of K&R (the GNU people aren't evil, they are
just severely misguided in this matter), so you just give indent the
options "-kr -i8" (stands for "K&R, 8 character indents"), or use
"scripts/Lindent", which indents in the latest style.

"indent" has a lot of options, and especially when it comes to comment
re-formatting you may want to take a look at the man page. But remember:
"indent" is not a fix for bad programming.

## Kconfig configuration files

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different. Lines under a "config"
definition are indented with one tab, while help text is indented an
additional two spaces. Example:

```kconfig
config AUDIT
	bool "Auditing support"
	depends on NET
	help
	  Enable auditing infrastructure that can be used with another
	  kernel subsystem, such as SELinux (which requires this for
	  logging of avc messages output).  Does not do system-call
	  auditing without CONFIG_AUDITSYSCALL.
```

Seriously dangerous features (such as write support for certain
filesystems) should advertise this prominently in their prompt string:

```kconfig
config ADFS_FS_RW
	bool "ADFS write support (DANGEROUS)"
	depends on ADFS_FS
	...
```

For full documentation on the configuration files, see the file
Documentation/kbuild/kconfig-language.txt.

Macros, Enums and RTL
---------------------

Names of macros defining constants and labels in enums are capitalized.

```c
#define CONSTANT 0x12345
```

Enums are preferred when defining several related constants.

CAPITALIZED macro names are appreciated but macros resembling functions
may be named in lower case.

Generally, inline functions are preferable to macros resembling
functions.

Macros with multiple statements should be enclosed in a do - while
block:

```c
#define macrofun(a, b, c)   \
    do {                    \
        if (a == 5)         \
            do_this(b, c);  \
    } while (0)
```

Things to avoid when using macros:

1) macros that affect control flow:

```c
#define FOO(x)              \
    do {                        \
	    if (blah(x) < 0)        \
		    return -EBUGGERED;  \
    } while(0)
```

is a *very* bad idea. It looks like a function call but exits the
"calling" function; don't break the internal parsers of those who
will read the code.

2) macros that depend on having a local variable with a magic name:

```c
#define FOO(val) bar(index, val)
```

might look like a good thing, but it's confusing as hell when one reads
the code and it's prone to breakage from seemingly innocent changes.

3) macros with arguments that are used as l-values: FOO(x) = y; will
bite you if somebody e.g. turns FOO into an inline function.

4) forgetting about precedence: macros defining constants using
expressions must enclose the expression in parentheses. Beware of
similar issues with macros using parameters.

```c
#define CONSTANT 0x4000
#define CONSTEXP (CONSTANT | 3)
```

The cpp manual deals with macros exhaustively. The gcc internals manual
also covers RTL which is used frequently with assembly language in the
kernel.

Printing coreboot messages
------------------------

coreboot developers like to be seen as literate. Do mind the spelling of
coreboot messages to make a good impression. Do not use crippled words
like "dont"; use "do not" or "don't" instead. Make the messages
concise, clear, and unambiguous.

coreboot messages do not have to be terminated with a period.

Printing numbers in parentheses (%d) adds no value and should be
avoided.

Allocating memory
-----------------

coreboot provides a single general purpose memory allocator: malloc()

The preferred form for passing a size of a struct is the following:

```c
p = malloc(sizeof(*p));
```

The alternative form where struct name is spelled out hurts readability
and introduces an opportunity for a bug when the pointer variable type
is changed but the corresponding sizeof that is passed to a memory
allocator is not.

Casting the return value which is a void pointer is redundant. The
conversion from void pointer to any other pointer type is guaranteed by
the C programming language.

You should contain your memory usage to stack variables whenever
possible. Only use malloc() as a last resort. In ramstage, you may also
be able to get away with using static variables. Never use malloc()
outside of ramstage.

Since coreboot only runs for a very short time, there is no memory
deallocator, although a corresponding free() is offered. It is a no-op.
Use of free() is not required though it is accepted. It is useful when
sharing code with other codebases that make use of free().

The inline disease
------------------

There appears to be a common misperception that gcc has a magic "make
me faster" speedup option called "inline". While the use of inlines
can be appropriate (for example as a means of replacing macros, see
Chapter 12), it very often is not.

A reasonable rule of thumb is to not put inline at functions that have
more than 3 lines of code in them. An exception to this rule are the
cases where a parameter is known to be a compile time constant, and as a
result of this constantness you *know* the compiler will be able to
optimize most of your function away at compile time. For a good example
of this later case, see the kmalloc() inline function.

Often people argue that adding inline to functions that are static and
used only once is always a win since there is no space tradeoff. While
this is technically correct, gcc is capable of inlining these
automatically without help, and the maintenance issue of removing the
inline when a second user appears outweighs the potential value of the
hint that tells gcc to do something it would have done anyway.

Function return values and names
--------------------------------

Functions can return values of many different kinds, and one of the most
common is a value indicating whether the function succeeded or failed.
Such a value can be represented as an error-code integer (`CB_ERR_xxx`
(negative number) = failure, `CB_SUCCESS` (0) = success) or a "succeeded"
boolean (0 = failure, non-zero = success).

Mixing up these two sorts of representations is a fertile source of
difficult-to-find bugs. If the C language included a strong distinction
between integers and booleans then the compiler would find these
mistakes for us... but it doesn't. To help prevent such bugs, always
follow this convention:

If the name of a function is an action or an imperative command,
the function should return an error-code integer.  If the name
is a predicate, the function should return a "succeeded" boolean.

For example, "add work" is a command, and the `add_work()` function
returns 0 for success or `CB_ERR` for failure. In the same way, "PCI
device present" is a predicate, and the `pci_dev_present()` function
returns 1 if it succeeds in finding a matching device or 0 if it
doesn't.

Functions whose return value is the actual result of a computation,
rather than an indication of whether the computation succeeded, are not
subject to this rule. Generally they indicate failure by returning some
out-of-range result. Typical examples would be functions that return
pointers; they use NULL to report failure.

Error handling, assertions and die()
-----------------------------

As firmware, coreboot has no means to let the user interactively fix things when
something goes wrong. We either succeed to boot or the device becomes a brick
that must be recovered through complicated external means (e.g. a flash
programmer). Therefore, coreboot code should strive to continue booting
wherever possible.

In most cases, errors should be handled by logging a message of at least
`BIOS_ERR` level, returning out of the function stack for the failed feature,
and then continuing execution. For example, if a function reading the EDID of an
eDP display panel encounters an I2C error, it should print a "cannot read EDID"
message and return an error code. The calling display initialization function
knows that without the EDID there is no way to initialize the display correctly,
so it will also immediately return with an error code without running its
remaining code that would initialize the SoC's display controller. Execution
returns further up the function stack to the mainboard initialization code
which continues booting despite the failed display initialization, since
display functionality is non-essential to the system. (Code is encouraged but
not required to use `enum cb_err` error codes to return these errors.)

coreboot also has the `die()` function that completely halts execution. `die()`
should only be used as a last resort, since it results in the worst user
experience (bricked system). It is generally preferrable to continue executing
even after a problem was encountered that might be fatal (e.g. SPI clock
couldn't be configured correctly), because a slight chance of successfully
booting is still better than not booting at all. The only cases where `die()`
should be used are:

1. There is no (simple) way to continue executing. For example, when loading the
   next stage from SPI flash fails, we don't have any more code to execute. When
   memory initialization fails, we have no space to load the ramstage into.

2. Continuing execution would pose a security risk. All security features in
   coreboot are optional, but when they are configured in the user must be able
   to rely on them. For example, if CBFS verification is enabled and the file
   hash when loading the romstage doesn't match what it should be, it is better
   to stop execution than to jump to potentially malicious code.

In addition to normal error logging with `printk()`, coreboot also offers the
`assert()` macro. `assert()` should be used judiciously to confirm that
conditions are true which the programmer _knows_ to be true, in order to catch
programming errors and incorrect assumptions. It is therefore different from a
normal `if ()`-check that is used to actually test for things which may turn
out to be true or false based on external conditions. For example, anything
that involves communicating with hardware, such as whether an attempt to read
from SPI flash succeeded, should _not_ use `assert()` and should instead just
be checked with a normal `if ()` and subsequent manual error handling. Hardware
can always fail for various reasons and the programmer can never 100% assume in
advance that it will work as expected. On the other hand, if a function takes a
pointer parameter `ctx` and the contract for that function (as documented in a
comment above its declaration) specifies that this parameter should point to a
valid context structure, then adding an `assert(ctx)` line to that function may
be a good idea. The programmer knows that this function should never be called
with a NULL pointer (because that's how it is specified), and if it was actually
called with a NULL pointer that would indicate a programming error on account of
the caller.

`assert()` can be configured to either just print an error message and continue
execution (default), or call `die()` (when `CONFIG_FATAL_ASSERTS` is set).
Developers are encouraged to always test their code with this option enabled to
make assertion errors (and therefore bugs) more easy to notice. Since assertions
thus do not always stop execution, they should never be relied upon to be the
sole guard against conditions that really _need_ to stop execution (e.g.
security guarantees should never be enforced only by `assert()`).

Headers and includes
---------------

Headers should always be included at the top of the file. Includes should
always use the `#include <file.h>` notation, except for rare cases where a file
in the same directory that is not part of a normal include path gets included
(e.g. local headers in mainboard directories), which should use `#include
"file.h"`. Local "file.h" includes should always come separately after all
<file.h> includes.  Headers that can be included from both assembly files and
.c files should keep all C code wrapped in `#ifndef __ASSEMBLER__` blocks,
including includes to other headers that don't follow that provision. Where a
specific include order is required for technical reasons, it should be clearly
documented with comments. This should not be the norm.

Files should generally include every header they need a definition from
directly (and not include any unnecessary extra headers). Excepted from
this are certain headers that intentionally chain-include other headers
which logically belong to them and are just factored out into a separate
location for implementation or organizatory reasons. This could be
because part of the definitions is generic and part SoC-specific (e.g.
`<gpio.h>` chain-including `<soc/gpio.h>`), architecture-specific (e.g.
`<device/mmio.h>` chain-including `<arch/mmio.h>`), separated out into
commonlib[/bsd] for sharing/license reasons (e.g. `<cbfs.h>`
chain-including `<commonlib/bsd/cbfs_serialized.h>`) or just split out
to make organizing subunits of a larger header easier. This can also
happen when certain definitions need to be in a specific header for
legacy POSIX reasons but we would like to logically group them together
(e.g. `uintptr_t` is in `<stdint.h>` and `size_t` in `<stddef.h>`, but
it's nicer to be able to just include `<types.h>` and get all the common
type and helper function stuff we need everywhere).

The headers `<kconfig.h>`, `<rules.h>` and `<commonlib/bsd/compiler.h>`
are always automatically included in all compilation units by the build
system and should not be included manually.

Don't re-invent common macros
-----------------------------

The header file `src/commonlib/bsd/include/commonlib/bsd/helpers.h`
contains a number of macros that you should use, rather than explicitly
coding some variant of them yourself. For example, if you need to
calculate the length of an array, take advantage of the macro

```c
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
```

Editor modelines and other cruft
--------------------------------

Some editors can interpret configuration information embedded in source
files, indicated with special markers. For example, emacs interprets
lines marked like this:

```
-*- mode: c -*-
```

Or like this:

```
/*
Local Variables:
compile-command: "gcc -DMAGIC_DEBUG_FLAG foo.c"
End:
*/
```

Vim interprets markers that look like this:

```
/* vim:set sw=8 noet */
```

Do not include any of these in source files. People have their own
personal editor configurations, and your source files should not
override them. This includes markers for indentation and mode
configuration. People may use their own custom mode, or may have some
other magic method for making indentation work correctly.

Inline assembly
---------------

In architecture-specific code, you may need to use inline assembly to
interface with CPU or platform functionality. Don't hesitate to do so
when necessary. However, don't use inline assembly gratuitously when C
can do the job. You can and should poke hardware from C when possible.

Consider writing simple helper functions that wrap common bits of inline
assembly, rather than repeatedly writing them with slight variations.
Remember that inline assembly can use C parameters.

Large, non-trivial assembly functions should go in .S files, with
corresponding C prototypes defined in C header files. The C prototypes
for assembly functions should use "asmlinkage".

You may need to mark your asm statement as volatile, to prevent GCC from
removing it if GCC doesn't notice any side effects. You don't always
need to do so, though, and doing so unnecessarily can limit
optimization.

When writing a single inline assembly statement containing multiple
instructions, put each instruction on a separate line in a separate
quoted string, and end each string except the last with nt to
properly indent the next instruction in the assembly output:

```c
asm ("magic %reg1, #42nt"
	"more_magic %reg2, %reg3"
	: /* outputs */ : /* inputs */ : /* clobbers */);
```

GCC extensions
--------------

GCC is the only officially-supported compiler for coreboot, and a
variety of its C language extensions are heavily used throughout the
code base. There have been occasional attempts to add clang as a second
compiler option, which is generally compatible to the same language
extensions that have been long-established by GCC.

Some GCC extensions (e.g. inline assembly) are basically required for
proper firmware development. Others enable more safe or flexible
coding patterns than can be expressed with standard C (e.g. statement
expressions and `typeof()` to avoid double evaluation in macros like
`MAX()`). Yet others just add some simple convenience and reduce
boilerplate (e.g. `void *` arithmetic).

Since some GCC extensions are necessary either way, there is no gain
from avoiding other GCC extensions elsewhere. The use of all official
GCC extensions is expressly allowed within coreboot. In cases where an
extension can be replaced by a 100% equivalent C standard feature with
no extra boilerplate or loss of readability, the C standard feature
should be preferred (this usually only happens when GCC retains an
older pre-standardization extension for backwards compatibility, e.g.
the old pre-C99 syntax for designated initializers). But if there is
any advantage offered by the GCC extension (e.g. using GCC zero-length
arrays instead of C99 variable-length arrays because they don't inhibit
`sizeof()`), there is no reason to deprive ourselves of that, and "this
is not C standard compliant" should not be a reason to argue against
its use in reviews.

This rule only applies to explicit GCC extensions listed in the
"Extensions to the C Language Family" section of the GCC manual. Code
should never rely on incidental GCC translation behavior that is not
explicitly documented as a feature and could change at any moment.

Refactoring
-----------
Because refactoring existing code can add bugs to tested code, any
refactors should be done only with serious consideration. Refactoring
for style differences should only be done if the existing style
conflicts with a documented coreboot guideline. If you believe that the
style should be modified, the pros and cons can be discussed on the
mailing list and in the coreboot leadership meeting.

Similarly, the original author should be respected. Changing working
code simply because of a stylistic disagreement is *prohibited*. This is
not saying that refactors that are objectively better (simpler, faster,
easier to understand) are not allowed, but there has to be a definite
improvement, not simply stylistic changes.

Basically, when refactoring code, there should be a clear benefit to
the project and codebase. The reviewers and submitters get to make the
call on how to interpret this.

When refactoring, adding unit tests to verify that the post-change
functionality matches or improves upon pre-change functionality is
encouraged.

References
----------

The C Programming Language, Second Edition by Brian W. Kernighan and
Dennis M. Ritchie. Prentice Hall, Inc., 1988. ISBN 0-13-110362-8
(paperback), 0-13-110370-9 (hardback). URL:
<https://duckduckgo.com/?q=isbn+0-13-110362-8> or
<https://www.google.com/search?q=isbn+0-13-110362-8>


The Practice of Programming by Brian W. Kernighan and Rob Pike.
Addison-Wesley, Inc., 1999. ISBN 0-201-61586-X. URL:
<https://duckduckgo.com/?q=ISBN+0-201-61586-X> or
<https://www.google.com/search?q=ISBN+0-201-61586-X>

GNU manuals - where in compliance with K&R and this text - for cpp, gcc,
gcc internals and indent, all available from
<http://www.gnu.org/manual/>

WG14 is the international standardization working group for the
programming language C, URL: <http://www.open-std.org/JTC1/SC22/WG14/>

Kernel CodingStyle, by greg@kroah.com at OLS 2002:
<http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/>
