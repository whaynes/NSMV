#!/usr/bin/env python3
import fnmatch
import os
import shutil

images = ['*.pdf', '*.png', '*.jpg', '*.jpeg', '*.svg', '*.ggb', '*.gif']
# these command line arguments are set by the makefile
resource_dir = "source/resources"  #(RESOURCES)
external_dir = "output/assets"  #(EXTERNAL)
css_dir = "output/web/_static/pretext/css/"

def flatten(match_patterns, source, dest):
    print(f"\tFlattening {match_patterns} in {source} to {dest}.")

    def pattern_filter(path):
        for pattern in match_patterns:
            if fnmatch.fnmatch(path.lower(), pattern):
               return path

    # setup
    if os.path.exists(dest):
        shutil.rmtree(dest)
    os.makedirs(dest)

    # flatten source to dest
    for root, dirs, files in os.walk(source):
        for file in filter(pattern_filter, files):
            this_file = os.path.join(root, file)
            target = os.path.join(dest, file)
            if '/_' in root: continue  # Skip any files in directories starting with underscore.
            if os.path.exists(target):  # Warn if this filename has been seen before.
                raise RuntimeError(f"***Duplicate filename*** \"{file}\" shadows a file with same name somewhere else in the source folder.")
            shutil.copy2(this_file, target)

def copy_and_overwrite(source, dest):
    if not os.path.exists(source):
      print(f"\t***Resource Missing*** Can't find '{source}'.")
    else:
      print(f"\tCopying {source} to {dest}.")
      if os.path.exists(dest):
          shutil.rmtree(dest)
      shutil.copytree(source, dest)
      
def copy_and_preserve(source, dest):
    if not os.path.exists(source):
      print(f"\t***Resource Missing*** Can't find '{source}'.")
    else:
      print(f"\tCopying {source} to {dest}.")
      shutil.copytree(source, dest, dirs_exist_ok=True)

print("update_assets.py")
print()
print(f"\tWorking dir: {os.getcwd()}")
print(f"\tResource Directory: {resource_dir}")
print(f"\tExternal Directory: {external_dir}")
print()

flatten(images, resource_dir, external_dir +'/images/')
copy_and_overwrite(resource_dir + '/images/_favicon', external_dir + '/favicon')
copy_and_overwrite(resource_dir + '/css', external_dir + '/css')  #my custom css

# put my theme color css in the right place
copy_and_preserve(resource_dir + '/css/theme/', css_dir)
print()
