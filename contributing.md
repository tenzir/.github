# Contributing

If you are looking to contribute to projects within the Tenzir organization,
please try to adhere to the respective projects existing coding style.

This document specifies our git and GitHub workflows, a set of recommendations
for different languages, and the coding style for VAST, which we use for all
our C++ and CMake projects. The style is based on STL, [Google
style][google-style], and [CAF style][caf-style] guidelines.

Documentation for Tenzir projects can be found at
[docs.tenzir.com](https://docs.tenzir.com).

[google-style]: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
[caf-style]: https://github.com/actor-framework/actor-framework/blob/master/CONTRIBUTING.md

## Git and GitHub Workflow

The following sketch visualizes our branching model:

![Branching Model](https://user-images.githubusercontent.com/53797/156560785-c7279447-63eb-4428-9a11-9c90cc03acc8.png)

Our git workflow looks as follows:

- The `master` branch reflects the latest state of development, and should
  always compile.

- In case we need to release a hotfix, we use dedicated patch release branches.

- The stable `branch` always points to the latest release that is not a release
  candidate. CI resets it automatically. It exists so support a streamlined
  workflow for some packaging tools (e.g., Nix).

- For new features or fixes, use *topic branches* that branch off `master` with
  a naming convention of `topic/description`. After completing work in a topic
  branch, check the following steps to prepare for a merge back into `master`:

  + Squash your commits such that each commit reflects a self-contained change.
    You can interactively rebase all commits in your current pull request with
    `git rebase --interactive $(git merge-base origin/master HEAD)`.

  + Create a pull request to `master` on GitHub.

  + Wait for the results of continuous integration tools and fix any reported
    issues.

  + Ask a maintainer to review your work when your changes merge cleanly. If
    you don't want a specific maintainer's feedback, ask for a review from the
    `tenzir/backend` or `tenzir/frontend` teams.

  + Address the feedback articulated during the review.

  + A maintainer will merge the topic branch into `master` after it passes the
    code review.

- Similarly, for features or fixes relating to a specific GitHub issue, use
  *issue branches* that branch off `master` with a naming convention of
  `issue/XXX`, replacing XXX with the issue number.

- Internally, we use [Shortcut](https://shortcut.com/) for project management,
  and employees are advised to create *story branches* that branch off `master`
  with a naming convention of `story/sc-XXX/description`, replacing XXX with
  the story number.

### Commit Messages

Commit messages are formatted according to [this git style
guide](https://github.com/agis/git-style-guide).

- The first line succinctly summarizes the changes in no more than 50
  characters. It is capitalized and written in and imperative present tense:
  e.g., "Fix a bug" as opposed to "Fixes a bug" or "Fixed a bug". As a
  mnemonic, prepend "When applied, this commit will" to the commit summary and
  check if it builds a full sentence.

- The first line does not contain a dot at the end. (Think of it as the header
  of the following description).

- The second line is empty.

- Optional long descriptions as full sentences begin on the third line,
  indented at 72 characters per line, explaining _why_ the change is needed,
  _how_ it addresses the underlying issue, and what _side-effects_ it might
  have.

## Dependency Management

When introducing a new dependency or updating an existing one, please consider
the following tasks:

- **CMake:** Determine whether the dependency is a public, private, or
  interface depdency or existing targets.

- **Nix**: Update the Nix environment to link against the proper dependency.

- **Dockerfile**: Update `Dockerfile` and `Dockerfile_prebuilt` to reflect the
  dependency changes.

- **CI**: Update the dependencies in GitHub Actions workflow files, including
  the Jupyter Notebook workflow.

- **Homebrew**: Notify the Homebrew package maintainer about the dependency
  changes.

- **Debian**: Notify the Debian package maintainer about the dependency
  changes.

## Coding Style

### Documentation

When documenting bugs, deficiencies, future tasks, or noteworthy things in the
code, we use two keywords that most editors and tools recognize: `FIXME:` and
`TODO:`. We use `FIXME` for a *known bug* and `TODO` for everything else. The
subsequent `:` is important for tooling, such as syntax highlighters. Here are
two examples:

```cpp
// FIXME: this currently fails on FreeBSD.
// FIXME: this algorithms is broken for i < 0.
```

A typical `TODO` could be:

```python
# TODO: refactor this code to separate mechanism from policy.
# TODO: add another argument to process user-defined tags.
```

### EditorConfig

- Some projects in the Tenzir organization provide `.editorconfig` files. Please
respect the settings defined in these. For many editors, plugins exist to
automatically apply EditorConfig files.

### Scripting Languages

- Scripts are executables (`chmod +x path/to/your-script`) and words in
  their names are separated using dashes (`your-script` over `your_script`).

- The first line of a script should be a shebang, e.g., `'#!/bin/sh'` or
  `#!/usr/bin/env python3`.

- The second line is empty.

- Starting at the third line, write a comment detailing usage instructions, and
  a short and concise description of the script.

#### Shell Scripts

- Prefer to use POSIX sh when possible.

- Tenzir uses [ShellCheck](https://github.com/koalaman/shellcheck) for linting.
  Pull request review feedback for shell scripts is in parts based on ShellCheck.

#### Python

- We use Python 3, with no special restrictions for newer features. Specify the
  minimum required version in the shebang, e.g. `#!/usr/bin/env python3.6`.

- Use [black](https://github.com/psf/black) for linting. Black is a heavily
  opinionated tool for both formatting and linting, and we found its opinion to
  be a good standard for us to use.

### Web Development

- All web-based projects in the Tenzir organization define style checkers and
  linters in their respective configuration files, so they are automatically
  applied.

### CMake

#### General

- Prefer targets and properties over variables.

- Don't use global *include_directories*.

- Export consumable targets to both build and install directories.

- Assign sensible export names for your targets, the `vast::` namespace is
  implicitly prefixed.

#### Formatting

- The cmake files are formatted with
  [cmake-format](https://github.com/cheshirekow/cmake_format).

### C++

#### General

- Use 2 spaces per indentation level.

- No tabs, ever.

- No C-style casts, ever.

- 80 characters max per line.

- Minimize vertical whitespace within functions. Use comments to separate
  logical code blocks.

- Namespaces and access modifiers (e.g., `public`) do not increase the
  indentation level.

- The `const` keyword precedes the type, e.g., `const T&` as opposed to
  `T const&`.

- `*` and `&` bind to the *type*, e.g., `T* arg` instead of `T *arg`.

- When declaring variables and functions, provide the [storage class
  specifier] (`extern`, `static`, `thread_local`, `mutable`) first, followed
  by the [declaration specifiers] in order of `friend`, `inline`, `virtual`,
  `explicit`, `constexpr`, `consteval`, and `constinit`.

[storage class specifier]: https://en.cppreference.com/w/cpp/language/storage_duration
[declaration specifiers]: https://en.cppreference.com/w/cpp/language/declarations#Specifiers

- Always use `auto` to declare a variable unless you cannot initialize it
  immediately or if you actually want a type conversion. In the latter case,
  provide a comment why this conversion is necessary.

- Never use unwrapped, manual resource management such as `new` and `delete`.

- Never use `typedef`; always write `using T = X` in favor of `typedef X T`.

- Keywords are always followed by a whitespace: `if (...)`, `template <...>`,
  `while (...)`, etc.

- Do not add whitespace when negating an expression with `!`:

  ```cpp
  if (!sunny())
    stay_home()
  ```

- Opening braces belong onto the same line:

  ```cpp
  struct foo {
    void f() {
    }
  };
  ```

- Use inline functions for trivial code, such as getters/setters or
  straight-forward logic that does not span more than 3 lines.

#### Header

- Header filenames end in `.hpp` and implementation filenames in `.cpp`.

- All header files should use `#pragma once` to prevent multiple inclusion.

- Don't use `#include` when a forward declarations suffices. It can make sense
  to outsource forward declarations into a separate file per module. The file
  name should be `<MODULE>/fwd.h`.

- Include order is from high-level to low-level headers, e.g.,

  ```cpp
  // iff a matching header exists
  #include "vast/matching_header.hpp"

  #include "vast/logger.hpp"

  #include <3rd/party.hpp>

  #include <memory>

  #include <sys/types.h>
  ```

  `clang-format` is configured to automatically change the include order
  accordingly. Includes separated by preprocessor directives need to be sorted
  manually.

  Within each section, the order should be alphabetical. VAST includes should
  always be in double quotes and relative to the source directory, whereas
  system-wide includes in angle brackets. See below for an example on how to
  structure includes in unit tests.

- As in the standard library, the order of parameters when declaring a function
  is: inputs, then outputs. API coherence and symmetry trumps this rule, e.g.,
  when the first argument of related functions model the same concept.

#### Classes

- Use the order `public`, `protected`, `private` for functions and members in
  classes.

- Mark single-argument constructors as `explicit` to avoid implicit
  conversions.

- The order of member functions within a class is: constructors, operators,
  mutating members, accessors.

- Friends first: put friend declaration immediate after opening the class.

- Put declarations (and/or definitions) of assignment operators right after the
  constructors, and all other operators at the bottom of the public section.

- Use structs for state-less classes or when the API is the struct's state.

- Prefer types with value semantics over reference semantics.

- Use the [rule of zero or rule of
  five](http://en.cppreference.com/w/cpp/language/rule_of_three).

- When providing a move constructor and move-assignment operator, declare them
  as `noexcept`.

- Use brace-initialization for member construction when possible. Only use
  parenthesis-initialization to avoid calling a `std::initializer_list`
  overload.

#### Naming

- Class names, constants, and function names are lowercase with underscores.

- Template parameter types should be written in CamelCase.

- Types and variables should be nouns, while functions performing an action
  should be "command" verbs. Getter and setter functions should be nouns. We do
  not use an explicit `get_` or `set_` prefix. Classes used to implement
  metaprogramming functions also should use verbs, e.g., `remove_const`.

- All library macros should start with `VAST_` to avoid potential clashes with
  external libraries.

- Names of (i) classes/structs, (ii) functions, and (iii) enums should be
  lower case and delimited by underscores.

- Put non-API implementation into namespace `detail`.

- Member variables have an underscore (`_`) as suffix, unless they constitute
  the public interface. Getters and setters use the same member name without
  the suffix.

- Put static non-const variables in an anonymous namespace.

- Name generic temporary or input variables `x`, `y`, and `z`. If such
  variables represent a collection of elements, use their plural form `xs`,
  `ys`, and `zs`.

- Prefix counter variables with `num_`.

- If a function has a return value, use `result` as variable name.

#### Breaking

- Break constructor initializers after the comma, use two spaces for
  indentation, and place each initializer on its own line (unless you don't
  need to break at all):

  ```cpp
  my_class::my_class()
    : my_base_class{some_function()},
      greeting_{"Hello there! This is my_class!"},
      some_bool_flag_{false} {
    // ok
  }

  other_class::other_class() : name_{"tommy"}, buddy_{"michael"} {
    // ok
  }
  ```

- Break function arguments after the comma for both declaration and invocation:

  ```cpp
  a_rather_long_return_type f(const std::string& x,
                              const std::string& y) {
    // ...
  }
  ```

  If that turns out intractable, break directly after the opening parenthesis:

  ```cpp
  template <typename T>
  black_hole_space_time_warp f(
    typename const T::gravitational_field_manager& manager,
    typename const T::antimatter_clustear& cluster) {
    // ...
  }
  ```

- Break template parameters without indentation:

  ```cpp
  template <class T>
  auto identity(T x) {
    return x;
  }
  ```

- Break trailining return types without indentation if they cannot fit on the
  same line:

  ```cpp
  template <class T>
  auto compute_upper_bound_on_compressed_data(T x)
  -> std::enable_if_t<std::is_integral_v<T>, T> {
    return detail::bound(x);
  }
  ```

- Break before binary and ternary operators:

  ```cpp
  if (today_is_a_sunny_day()
      && it_is_not_too_hot_to_go_swimming()) {
    // ...
  }
  ```

#### Template Metaprogramming

- Use the `typename` keyword only to access dependent types. For general
  template parameters, use `class` instead:

  ```cpp
  template <class T>
  struct foo {
    using type = typename T::type;
  };
  ```

- Use `T` for generic, unconstrained template parameters and `x` for generic
  function arguments. Suffix both with `s` for template parameter packs:

  ```cpp
  template <class T, class... Ts>
  auto f(T x, Ts... xs) {
    // ...
  }
  ```

- Break `using name = ...` statements always directly after `=` if they do not
  fit in one line.

- Use one level of indentation per "open" template and place the closing `>`,
  `>::type` or `>::value` on its own line. For example:
  ```cpp
  using optional_result_type =
    typename std::conditional<
      std::is_same<result_type, void>::value,
      bool,
      optional<result_type>
    >::type;
  ```

- When dealing with "ordinary" templates, use indentation based on the position
  of the last opening `<`:
  ```cpp
  using type = quite_a_long_template_which_needs_a_break<std::string,
                                                         double>;
  ```

- When adding new type traits, also provide `*_t` and/or `*_v` helpers:
  ```cpp
  template <class T>
  using my_trait_t = typename my_trait<T>::type;

  template <class T>
  constexpr auto my_trait_v = my_trait<T>::value;
  ```

#### Logging

- Available log levels are *ERROR*, *WARNING*, *INFO*, *DEBUG* and *TRACE*.

- Messages can be sent by using the VAST_\<level> and VAST_\<level>_ANON macros.

- The VAST_\<level> macros are intended to be used with a subject as the fist
  argument. Use them to create a sentence of the form 'subject verb object'.
  For example:
  ```cpp
  VAST_WARNING(self, "got a request for unknown query ID", query_id);
  ```

  Which gets printed as:
  ```sh
  index got a request for unkown query ID <181f5b1f-c673-4e98-acd2-ef762fe567a2>
  ```

- The VAST_\<level>_ANON macros are available for situations where **n**o
  **s**ubject is suitable for the first argument to the other macro variant.
  They can either be used to inject a subject manually, or create a message
  in the *gerund* form. For example:
  ```cpp
  VAST_DEBUG_ANON(__func__, "creating directory", dir);
  ```

- By default, use the VAST_\<level> variants.

- Try to restrict usage of the VAST_INFO message type to the main actors.
  Info is the chattiest level that most users will see, so it should require
  no or only little understanding of VASTs system architecture for the
  reader to understand.

- Messages sent at the trace level add the additional effect of writing a
  second message at the exit of the current scope. The trace level can be
  used to create a trace of the call stack with fine grained control over
  its depth. Omit trace messages from helper functions and generic / general
  purpose algorithm implementations.


#### Comments

- Doxygen comments start with `///`.

- Use Markdown instead of Doxygen formatters.

- Use `@cmd` rather than `\cmd`.

- Document pre- and post-conditions with `@pre` and `@post` (where appropriate).

- Reference other parameters with emphasis:
  ```cpp
  /// @param x A number between 0 and 1.
  /// @param y Scales *x* by a constant factor.
  ```

- Use `@tparam` to document template parameters.

- For simple getters or obvious functions returning a value, use a one-line
  `@returns` statement:
  ```cpp
  /// @returns The answer.
  int f();
  ```

- Use `//` or `/*` and `*/` to define basic comments that should not be
  swallowed by Doxygen.

#### External Files

When integrating 3rd-party code into the code base, use the following scaffold:

```cpp
/******************************************************************************
 *                    _   _____   __________                                  *
 *                   | | / / _ | / __/_  __/     Visibility                   *
 *                   | |/ / __ |_\ \  / /          Across                     *
 *                   |___/_/ |_/___/ /_/       Space and Time                 *
 *                                                                            *
 * This file is part of VAST. It is subject to the license terms in the       *
 * LICENSE file found in the top-level directory of this distribution and at  *
 * http://vast.io/license. No part of VAST, including this file, may be       *
 * copied, modified, propagated, or distributed except according to the terms *
 * contained in the LICENSE file.                                             *
 ******************************************************************************/

// This file comes from a 3rd party and has been adapted to fit into the VAST
// code base. Details about the original file:
//
// - Repository: https://github.com/Microsoft/GSL
// - Commit:     d6b26b367b294aca43ff2d28c50293886ad1d5d4
// - Path:       GSL/include/gsl/gsl_byte
// - Author:     Microsoft
// - Copyright:  (c) 2015 Microsoft Corporation. All rights reserved.
// - License:    MIT

(code here)
```

#### Unit Tests

- Every new feature must come with unit tests.

- The filename and path should mirror the component under test. For example,
  the component `vast/detail/feature.hpp` should have a test file called
  `test/detail/feature.cpp`.

- The include order in unit tests resembles the order for standard headers,
  except that unit test includes and the suite definition comes at the top.

- Make judicious use of *fixtures* for prepping your test environment.

- The snippet below illustrates a simple example for a new component
  `vast/foo.hpp` that would go into `test/foo.cpp`.

  ```cpp
  /******************************************************************************
   *                    _   _____   __________                                  *
   *                   | | / / _ | / __/_  __/     Visibility                   *
   *                   | |/ / __ |_\ \  / /          Across                     *
   *                   |___/_/ |_/___/ /_/       Space and Time                 *
   *                                                                            *
   * This file is part of VAST. It is subject to the license terms in the       *
   * LICENSE file found in the top-level directory of this distribution and at  *
   * http://vast.io/license. No part of VAST, including this file, may be       *
   * copied, modified, propagated, or distributed except according to the terms *
   * contained in the LICENSE file.                                             *
   ******************************************************************************/

  #define SUITE foo

  #include "vast/foo.hpp" // Unit under test

  #include "test.hpp"     // Unit test framework and scaffolding

  #include <iostream>     // standard library includes

  #include <caf/...>      // CAF includes

  #include "vast/..."     // VAST includes

  using namespace vast;

  namespace {

  struct fixture {
    fixture() {
      // Setup
      context = 42;
    }

    ~fixture() {
      // Teardown
      context = 0;
    }

    int context;
  };

  } // namespace <anonymous>

  FIXTURE_SCOPE(foo_tests, fixture)

  TEST(construction) {
    MESSAGE("default construction");
    foo x;
    MESSAGE("assignment");
    x = 42;
    CHECK_EQUAL(x, context);
  }

  FIXTURE_SCOPE_END()
  ```

#### Continuous Integration

We use GitHub Actions to build and test each commit. Merging a pull request
requires that all checks pass for the latest commit in the branch. GitHub
displays the status of the individual checks in the pull request.
