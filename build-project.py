import os
import subprocess
import sys
import glob
import shutil

if len(sys.argv) < 2:
    print("ERROR: Project dir is required")
    print("Usage: {} <project-dir>".format(sys.argv[0]))
    sys.exit(1)

project_dir = sys.argv[1]
if not os.path.exists(project_dir):
    print("Project dir {} does not exist".format(project_dir))
    sys.exit(1)

# convert './asteroids/' -> 'asteroids'
project_name = [x for x in os.path.split(project_dir) if x][-1]
project_name = project_name.replace('.', '').replace('/', '')


godot_path = os.getenv("GODOT", "/Applications/Godot.app/Contents/MacOS/Godot")
mode = os.getenv("MODE", "HTML5")
build_tag = project_name
dist_dir = os.path.join(project_dir, "dist")


def run_cmd(cmd):
    print('Run: %s' % ' '.join(cmd))
    ret = subprocess.call(cmd)
    if ret != 0:
        print('Failed [ret=%s]: %s' % (ret, cmd))
        sys.exit(ret)

print("Cleaning up previously built files")
built_files = glob.glob("%s/%s*" % (project_dir, build_tag))
for f in built_files:
    print('Removing %s' % f)
    try:
        os.remove(f)
    except OSError:
        pass

print('Removing %s' % dist_dir)
shutil.rmtree(dist_dir, ignore_errors=True)

print('Exporting project %s' % project_dir)
run_cmd([
    godot_path,
    '--path', os.path.realpath(project_dir),
    '--export', mode,
    build_tag
])

built_files = glob.glob("%s/%s*" % (project_dir, build_tag))
for f in built_files:
    print('Built file: %s' % f)

print('Creating directory %s' % dist_dir)
os.mkdir(dist_dir)

for f in built_files:
    filename = os.path.split(f)[-1]
    parts = filename.split('.', 1)
    if len(parts) == 1 and mode.lower() == 'html5':
        dest_file = os.path.join(dist_dir, filename + '.html')
    else:
        dest_file = os.path.join(dist_dir, filename)
    print('Moving %s -> %s' % (f, dest_file))
    shutil.move(f, dest_file)
