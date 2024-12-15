# Engineering Training Manual


The *Engineering Training Manual* is the engineering textbook for  *T.S. Patriot State*, the training vessel of [Massachusetts Maritime Academy](https://maritime.edu), as well as other National Security Multimission Vessels.

January 2025  Status: Work in progress



## Authoring and deployment instructions

This book is authored with PreTeXt.  Visit <https://pretextbook.org/documentation.html> to learn more.

### Whitespace

This project uses [pretext-formatter](https://github.com/skiadas/ptx-formatter) to maintain whitespace consistency in the PreTeXt source.  After making changes to any  .ptx files, issue the command command below from the  `statics/source/ptx` directory to normalize the whitespace and make changes easier to identify.  

`ptx-format -c ptx-format.cfg -pr .`

This command will format all the ptx files found in the source directory, the  `-c` means use the specified config file to set the formatting options.  `-p` tells the script to make the changes in place, i.e. overwrite the PreTeXt files, and  the `-r` means recursive, i.e. format all ptx files in the directory.

### Asset management

The source for several assets may be found at `source/resources`. These output files must have unique names, and must be copied into the gitignored `assets`  where they can be seen by PreTeXt, using the `update_assets.py` script:

```bash
python scripts/update_assets.py
```

This process must be done once when the project is cloned from Git, and repeated
each time an asset in `source/resources` is updated.

### Building

To build HTML and PDF versions of the book using the CLI after managing assets
(see above):

```bash
pretext build web --clean
pretext build print --clean
```

### Deploying

To preview how this book will appear upon a deploy to [https://whaynes.github.io/NSMV/](https://whaynes.github.io/NSVM/):

```bash
rm -rf output/stage # to remove cached files
pretext deploy --stage-only
pretext view # open /output/stage in your browser
```

To deploy updates to [https://whaynes.github.io/NSMV/](https://whaynes.github.io/NSMV/):

```bash
## after adding/commiting everything with Git
rm -rf output/stage # to remove cached files
pretext deploy
```
