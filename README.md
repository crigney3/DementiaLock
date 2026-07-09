# DementiaLock

The patrons keep forgetting which character they're talking to.

*This is a sound-only mod.*

**No AI or Original VO is used in this mod!** It is entirely cuts of existing Deadlock voicelines.

## Installing DementiaLock

**Available on [GameBanana](https://gamebanana.com/sounds/91070)**, please use the [Deadlock Mod Manager](https://deadlockmods.app/) to install.

# Contributing Voicelines

All VO in DementiaLock is done by cutting together character-specific patron dialogue with patron dialogue for a different character. For example, the Abrams killstreak line "The detective fights for us all" would be replaced with "The detective, you are burning them to cinders".

**Absolutely no AI voices or original VO is used or allowed in this project!** Think of DementiaLock like old TF2 cut-together voicelines.

## How to Edit a Voiceline

Generally, following [this tutorial](https://deadlockmodding.pages.dev/modding-guides/replacing-sounds) will put you on the right track. Full path to relevant sounds in Source2Viewer is:

`citadel/pak01_dir.vpk -> sounds/vo/announcer/(fe)male_patron/desired_voiceline.vsnd_c`

You can also find the original, unmodified files as already-decompiled files in `Originals/`. No PRs may be made to this folder, except to fix corrupted files/add missing files.

Each character's name, along with different ways refer to them, are stored in `NameCuts/`. PRs may be made to this folder to add non-standard references to characters that I missed; "the detective" vs "Abrams". Audio files here must contain only words specifically referring to a character, to make editing easier. `NameCuts/` is not meant to have modified lines; it is a repository of all character names in deadlock as audio from the patrons.

Editing can be done in any program as long as the final output is .mp3. I recommend [Audacity](https://www.audacityteam.org/). If you're unfamiliar with cutting multiple audio files together, it's basically these steps every time (assuming Audacity):

1. Open the original line in Audacity
2. Select the name/character reference to remove, ctrl+alt+x to remove it while leaving blank space. Select the start of the track to deselect.
3. Drag the NameCut you want into Audacity, it will appear as a separate track.
4. Press f5 for the time shift tool. Move the tracks so they line up (or close to line up, sometimes that sounds better.)
5. Export to mp3! Make sure it's in the correct folder under `Modified/` and has the correct name so it gets picked up by soundevents.

## Designing Your Voiceline

Not sure where to start? Check out all the lines for the [Hidden King](https://deadlock.wiki/The_Hidden_King/Quotes) and [Archmother](https://deadlock.wiki/The_Archmother/Quotes) on the Deadlock Wiki!

### Types of Modified VO

1. **Right Motivations, Wrong Name** - Example: replace Victor's patron intro with the same 'summon me to find closure' line, but with Ivy's name instead.
2. **Wrong Motivations, Right Name** - Example: replace Victor's patron intro about finding closure, using the Victor NameCut file combined with someone else's intro, i.e. the Ivy intro line about making life better for the arroyos.
3. **Full Youtube Poop** - Example: swapping in random nouns where names should be, making the Archmother call Victor an idiot instead of his name, etc.

### General Rules (Break em if it's funny)

* Put the name/character reference wherever the previous name was. Example: `The detective fights for us all` becomes `Victor fights for us all`.
* Don't mix and match hidden king lines with archmother lines. This rule almost definitely shouldn't be broken - it'd have to be *really* funny.
* No overwriting `"Minaaaa Haaaaaa, rise up and take what you deserve!"`. Even the dementia-addled patrons can't forget the perfect voiceline. You can use that line as much as you want, just don't put a line with the filename `patron_(fe)male_ally_vampirebat_killing_streak_01` into `Modified/`, because then we'd lose perfection.
* Don't make a line fully out of context. It should somehow refer to the character or a joke about the character who is hearing the line.
* Don't make a line much longer than the original unless you know what you're doing and modify `vsnd_duration` appropriately.

### Upper Limits

Technically, we can add as many lines as we want. **However**, once there are as many lines in the relevant `Modified/` subfolder as the relevant `Originals/` subfolder, new lines will need to added to the relevant vsndevts (usually generated_vo_misc.vsndevts). Try and spread additions to vsndevts's `vsnd_files` arrays evenly; if you're adding 5 Yamato intro lines, placing them all in `patron_male_ally_yamato_start_01_announcer` will mean there's only a 1/6 chance to play your line after the 1/5 chance to get that sound event. If instead you put one in each of `patron_male_ally_yamato_start_01_announcer` through `patron_male_ally_yamato_start_05_announcer`, you have a much higher chance of hearing your line in game.

### Voiceline Examples

(Github doesn't natively support playing audio, so you'll need to download the files if you want to hear the examples.)

[An intro line using the correct character, but the wrong context](https://github.com/crigney3/DementiaLock/tree/main/Modified/HiddenKing/Intro/Rem/patron_male_ally_familiar_start_02.mp3)

[An intro line using the wrong character, but the correct context](https://github.com/crigney3/DementiaLock/tree/main/Modified/HiddenKing/Intro/Celeste/patron_male_ally_unicorn_start_01.mp3)

[A killstreak line that swaps the names for a classic Youtube Poop](https://github.com/crigney3/DementiaLock/blob/main/Modified/Archmother/Killstreak/Enemy/Silver/patron_female_enemy_werewolf_killing_streak_medium_01.mp3)

## Compiling and Testing Your Voiceline(s)

You don't need to submit compiled files; mp3s are what I'm looking for. I will handle compilation and submission.

*If you're making a change beyond replacing an existing voiceline or adding to a vsnd_files array*, please compile and test your work before sending in a PR. The most commonly used SoundEvents files are in `SoundEvents/`. [The audio tutorial](https://deadlockmodding.pages.dev/modding-guides/replacing-sounds) covers how to recompile assets for testing with the CSDK12 tools. [Deadlock Forge](https://deadlockforge.net/) Also offers an easy way to compile your sounds into a VPK, although it can't modify soundevents.

To play a specific soundevent in the deadlock in-game console, use this command: `snd_sos_start_soundevent path_to_soundevent`. Playing a specific sound is easier: `play path_to_sound`.

## Submitting Your Voiceline(s)

Fork this repo and place the edited audio files into `Modified/path/to/specific/line/your_line.mp3`. Make sure the file is exactly the same name as the original! If it's not (usually because that character interaction has already had all their voicelines modified), make sure to add it to the relevent vsndevts file and include that in your PR. Try and keep the filename scheme: `patron_{patron's gender}_{ally/enemy}_{character}_{action}_{number from 01 to 99, ascending from previous}`

Remember:
* You may not replace an existing modified line.
* If you've added more variant lines, ensure they stick to the format mentioned above.
* Make sure your PR only contains your changes, and not random spare files.
* If you're adding files to NameCuts, keep that as a separate PR from adding modified lines. Also try to keep the name scheme in line.

If your PR is approved, I'll add you as a contributor to the mod on GameBanan! If you have a GameBanana username you want me to use, or a specific way you want to be credited, please say so in your PR.