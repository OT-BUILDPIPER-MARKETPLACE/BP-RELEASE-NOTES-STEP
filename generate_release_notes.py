import subprocess
import datetime
import os
from jinja2 import Template

def get_git_log(path):
    result = subprocess.run(
        ['git', '-C', path, 'log', '--pretty=format:%h - %s (%an)', 'HEAD^..HEAD'],
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

def format_release_notes(path):
    log = get_git_log(path)
    current_date = datetime.datetime.now().strftime('%Y-%m-%d')

    template = Template("""
    # Release Notes - {{ date }}

    ## Changes

    {% for line in log.split('\n') %}
    - {{ line }}
    {% endfor %}
    """)

    return template.render(date=current_date, log=log)

def save_release_notes(content, path):
    release_notes_path = os.path.join(path, 'release_notes.md')
    with open(release_notes_path, 'w') as f:
        f.write(content)
    return release_notes_path

def git_add_commit_push(path, file_path):
    subprocess.run(['git', '-C', path, 'add', file_path], check=True)
    subprocess.run(['git', '-C', path, 'commit', '-m', 'Add release notes'], check=True)
    subprocess.run(['git', '-C', path, 'push'], check=True)

if __name__ == '__main__':
    import sys
    path = sys.argv[1] if len(sys.argv) > 1 else '.'
    release_notes_content = format_release_notes(path)
    release_notes_path = save_release_notes(release_notes_content, path)
    git_add_commit_push(path, release_notes_path)
