# ChidoriMenu 🐦⚡️

An easy way to add popover menus visually similar to the [Context Menus](https://developer.apple.com/design/human-interface-guidelines/ios/controls/context-menus/) and [Pull Down Menus](https://developer.apple.com/design/human-interface-guidelines/ios/controls/pull-down-menus/) iOS uses but with some advantages. (Effectively just a rebuild of Pull Down Menus as a custom view controller to gain some flexibility.)

Copied most of the code from [https://github.com/christianselig/ChidoriMenu](https://github.com/christianselig/ChidoriMenu), same license.

## Features

- [x] Added support for UIMenu & UIAction
- [x] Added drop in replacement for `_presentMenuAtLocation:` (not recommended)
- [x] Added support for nested menus in children
- [x] Added support for menu option: `.displayInline`
- [x] Added support for dark mode
- [x] Fixed scrolling issue with selection
- [x] Fixed multiple action called at the same time
- [ ] Added support for UIDeferredMenuElement (Help Wanted)

## Requirements

- iOS 15.0+
- macCatalyst 15.0+

## Usage

```
UIButton.presentMenu()
UIView.present(menu: menu)
```

## License

[MIT License](./LICENSE)

---

2023.9, Made with love by Lakr233