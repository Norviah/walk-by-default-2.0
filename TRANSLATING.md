## Creating A Translation

### Translating

All text needed to be translated is located
[here](./redscript/Localization/Packages/English.reds), which you can use as a
reference. Copy this file and rename it to the language you are translating to,
for example: `Russian.reds`.

For each line, translate the second string in the function. As an example, for 
line 13, you would translate `Prevents the game from disabling the walking
state.`. Be sure to keep the double quotes around the translated text.

Finally, change `English` in line 5 to the language you are translating to, for
example: `Russian`.

### Adding The Translation

Once you have translated all the text, you need to add it to the provider
[here](./redscript/Localization/LocalizationProvider.reds). In the switch case
in the `GetPackage` function, you need to add a new case for your language.
Right above `default`, add a new case like so:

```
case n"ru-ru":
  return new Russian();
```

This will point the provider to your translation if the game's language is set
to your language.

Here is the full example of how the function should look after adding the
Russian translation:

```swift
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"en-us":
        return new English();
      case n"ru-ru":
        return new Russian();
      default:
        return null;
    }
  }
```

### Testing the Translation

To test the translation, do a clean start of the game and set the language to
the one you translated to. Once in-game, the mod's settings and the popup
menu should now reflect your translation.

### Pushing the Translation

Once you are done translating, create a pull request with your changes and I'll
update the mod with your translation. Feel free to add your nexusmod's username
in the message so I can credit you in the update.

If I take more than a few days to accept your translation and update the mod,
feel free to message me on Discord (my username is `norviah`) or on NexusMods to
remind me.