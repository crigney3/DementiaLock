# DementiaLock

The patrons keep forgetting which character they're talking to.

*This is a sound-only mod.*

## Installing DementiaLock

*TODO on first release, should be same as any other sound mod*

# Contributing Voicelines

All VO in DementiaLock is done by cutting together character-specific patron dialogue with patron dialogue for a different character. For example, the Abrams killstreak line "The detective fights for us all" would be replaced with "The detective, you are burning them to cinders".

**Absolutely no AI voices or original VO is used or allowed in this project!** Think of DementiaLock like old TF2 cut-together voicelines.

## How to Edit a Voiceline

Generally, following [this tutorial](https://gamebanana.com/tuts/19072) will put you on the right track. Full path to relevant sounds in Source2Viewer is:

`citadel/pak01_dir.vpk -> sounds/vo/announcer/(fe)male_patron/desired_voiceline.vsnd_c`

You can also find the original, unmodified files as already-decompiled files in `Originals/`. No PRs may be made to this folder, except to fix corrupted files.

Each character's name, along with different ways refer to them, are stored in `NameCuts/`. PRs may be made to this folder to add non-standard references to characters that I missed; "the detective" vs "Abrams". Audio files here must contain only words specifically referring to a character, to make editing easier. `NameCuts/` is not meant to have modified lines; it is a repository of all character names in deadlock as audio from the patrons.

Editing can be done in any program as long as the final output is .mp3. I recommend [Audacity](https://www.audacityteam.org/). If you're unfamiliar with cutting multiple audio files together, do some quick googling - I promise it's a very easy edit.

## Designing Your Voiceline

The general rule is to have the patrons correctly refer to the character, but use the wrong information about them. So if you wanted to replace Victor's patron intro about finding closure, you would use the Victor NameCut file combined with someone else's intro, i.e. the Ivy intro line about making life better for the arroyos. You can also have the patron refer to the wrong character but with the right information, but we want to avoid having both pieces be wrong.

Don't mix and match hidden king lines with archmother lines. This rule almost definitely shouldn't be broken - it'd have to be *really* funny.

Generally, put the name/character reference wherever the previous name was. Example: `The detective fights for us all` becomes `Victor fights for us all`.

Before you choose a voiceline to edit, **MAKE SURE that a line of the same file name does not already exist in the `Modified/` subfolders!** Individual voicelines are first-come, first-serve. If someone has already replaced the word "wraith" in `patron_male_enemy_wraith_killing_streak_high_01`, and that file was accepted into `Modified/`, you'll have to find another voiceline to edit.

No edits may be made to `"Minaaaa Haaaaaa, rise up and take what you deserve!"`. Even the dementia-addled patrons can't forget the perfect voiceline. (`patron_(fe)male_ally_vampirebat_killing_streak_01`, for reference)

## Compiling and Testing Your Voiceline(s)

You don't need to submit compiled files; mp3s are what I'm looking for. I will handle compilation and submission.

*If you're making a change beyond replacing an existing voiceline*, such as adding more variants of a line than exist in base game, please compile and test your work before sending in a PR. The most commonly used SoundEvents files are in `SoundEvents/`.

To play a specific sound in the deadlock in-game console, use this command: `snd_sos_start_soundevent soundevent_name`

## Submitting Your Voiceline(s)

Fork this repo and place the edited audio files into `Modified/path/to/specific/line/your_line.mp3`. Make sure the file is exactly the same name as the original!

Remember:
* You may not replace an existing modified line.
* If you've added more variant lines, ensure their names contain "new_" at the start.
* Make sure your PR only contains your changes, and not random spare files.
* If you're adding files to NameCuts, keep that as a separate PR from adding modified lines. Also try to keep the name scheme in line.

If your PR is approved, I'll add your name to Contributors.txt and credit you on the mod page! If you want to be credited as something other than your github handle, please say so in your PR.