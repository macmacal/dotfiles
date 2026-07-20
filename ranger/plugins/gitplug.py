import subprocess
import os
from ranger.api.commands import Command


class git(Command):
    commands = "init status clone add rm restore commit remote push reset checkout pull fetch diff"

    def execute(self):

        def is_git_repo():
            output = subprocess.run(
                ["git", "rev-parse", "--is-inside-work-tree"],
                capture_output=True,
                text=True,
            )
            if "true" not in output.stdout:
                return False
            return True

        match self.arg(1):
            case "help":
                return self.fm.notify("Supported git commands: " + self.commands)

            case "status":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                output = subprocess.run(
                    ["git", "status"], capture_output=True, text=True
                )
                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)

                with open("/tmp/gitplug-status", "w") as out:
                    out.write(output.stdout)

                return self.fm.edit_file("/tmp/gitplug-status")

            case "init":
                output = subprocess.run(["git", "init"], capture_output=True, text=True)
                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)
                else:
                    return self.fm.notify("git: " + output.stdout)

            case "clone":
                if not self.arg(2):
                    return self.fm.notify("Missing url!", bad=True)

                if self.arg(2):
                    subprocess.run(["git", "clone", self.arg(2), "--quiet"])
                    return self.fm.notify("Repository successfully cloned!")

            case "add":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if not self.arg(2):
                    return self.fm.notify(
                        "Missing arguments! Usage :git add <file>", bad=True
                    )

                if not os.path.exists(self.arg(2)):
                    return self.fm.notify("File or folder does not exist", bad=True)

                output = subprocess.run(
                    ["git", "add", self.arg(2)], capture_output=True, text=True
                )
                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)
                return self.fm.notify("git: Successfully added files to branch!")

            case "rm":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if not self.arg(2):
                    return self.fm.notify(
                        "Missing arguments! Usage :git rm <file>", bad=True
                    )

                if not os.path.exists(self.arg(2)):
                    return self.fm.notify("File or folder does not exist", bad=True)

                subprocess.run(
                    ["git", "rm", self.arg(2)], capture_output=True, text=True
                )
                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)
                return self.fm.notify("git: Successfully removed files from branch!")

            case "restore":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if not self.arg(2):
                    return self.fm.notify(
                        "Missing arguments! Usage :git restore <file>", bad=True
                    )

                if not os.path.exists(self.arg(2)):
                    return self.fm.notify("File or folder does not exist", bad=True)

                subprocess.run(["git", "restore", "--staged", self.arg(2), "--quiet"])
                return self.fm.notify("Successfully restored files!")

            case "commit":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if not self.rest(2):
                    return self.fm.notify("Missing commit text", bad=True)

                output = subprocess.run(
                    ["git", "commit", "-m", self.rest(2)],
                    capture_output=True,
                    text=True,
                )
                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)
                return self.fm.notify(
                    "git: Successfully committed! " + output.stdout.splitlines()[1]
                )

            case "remote":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                match self.arg(2):
                    case "add":
                        if not self.arg(3):
                            return self.fm.notify("Missing name and url!", bad=True)

                        if not self.arg(4):
                            return self.fm.notify("Missing url!", bad=True)

                        subprocess.run(
                            ["git", "remote", "add", self.arg(3), self.arg(4)]
                        )
                        return self.fm.notify("Remote successfully added!")

                    case "rm":
                        if not self.arg(3):
                            return self.fm.notify("Missing name!", bad=True)

                        if self.arg(3):
                            subprocess.run(["git", "remote", "rm", self.arg(3)])
                            return self.fm.notify("Remote successfully removed")
                    case _:
                        return self.fm.notify(
                            "Missing arguments! Use: git remote add/rm <name> <url>",
                            bad=True,
                        )

            case "push":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if self.arg(2) == "-u" and self.arg(3) and self.arg(4):
                    subprocess.run(
                        ["git", "push", "--quiet", "-u", self.arg(3), self.arg(4)]
                    )
                    return self.fm.notify("Repository successfully pushed")

                if not self.arg(2):
                    subprocess.run(["git", "push", "--quiet"])
                    return self.fm.notify("Repository successfully pushed")

            case "reset":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                if self.arg(2) == "--hard":
                    output = subprocess.run(
                        ["git", "reset", "--hard"], capture_output=True, text=True
                    )
                    if output.returncode != 0:
                        return self.fm.notify("git: " + output.stderr, bad=True)
                    return self.fm.notify("Repository hard reset!")

                if self.arg(2) == "--soft":
                    output = subprocess.run(
                        ["git", "reset", "--soft"], capture_output=True, text=True
                    )
                    if output.returncode != 0:
                        return self.fm.notify("git: " + output.stderr, bad=True)
                    return self.fm.notify("Repository soft reset!")

                return self.fm.notify("Usage: git reset [--hard | --soft]")

            case "checkout":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                match self.arg(2):
                    case None:
                        return self.fm.notify(
                            "Usage: git checkout <branch-name> or git checkout -b <new-branch>",
                            bad=True,
                        )
                    case "-b" if self.arg(3):
                        output = subprocess.run(
                            ["git", "checkout", "-b", self.arg(3)],
                            capture_output=True,
                            text=True,
                        )
                        if output.returncode != 0:
                            return self.fm.notify("git: " + output.stderr, bad=True)
                        return self.fm.notify(
                            f"Created and switched to new branch '{self.arg(3)}'"
                        )
                    case _:
                        output = subprocess.run(
                            ["git", "checkout", self.arg(2)],
                            capture_output=True,
                            text=True,
                        )
                        if output.returncode != 0:
                            return self.fm.notify("git: " + output.stderr, bad=True)
                        return self.fm.notify(f"Switched to branch '{self.arg(2)}'")

            case "pull":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                output = subprocess.run(["git", "pull"], capture_output=True, text=True)

                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)

                if "Already up to date" in output.stdout:
                    return self.fm.notify("git: Already up to date.", bad=True)

                if "CONFLICT" in output.stdout:
                    with open("/tmp/gitplug-conflict", "w") as out:
                        out.write(output.stdout)

                    return self.fm.edit_file("/tmp/gitplug-conflict")

                return self.fm.notify(
                    "git: Successfully pulled updates from remote repository."
                )

            case "fetch":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)
                output = subprocess.run(
                    ["git", "fetch"], capture_output=True, text=True
                )

                if output.returncode != 0:
                    return self.fm.notify("git: " + output.stderr, bad=True)

                return self.fm.notify(
                    "git: Successfully fetched updates from remote repository."
                )

            case "diff":
                if not is_git_repo():
                    return self.fm.notify("git: This is not a valid git repo", bad=True)

                cmd = ["git", "diff"]
                if self.arg(2):
                    cmd.append(self.arg(2))
                self.fm.ui.suspend()
                process = subprocess.Popen(cmd, env=os.environ)
                process.wait()
                self.fm.ui.initialize()

            case _:
                return self.fm.notify(
                    "Command not supported, use :git help for all supported commands",
                    bad=True,
                )
