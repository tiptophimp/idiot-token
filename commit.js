import { Octokit } from "@octokit/rest";
import fs from "fs";
import dotenv from "dotenv";

dotenv.config();

const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });

const owner = process.env.GITHUB_OWNER;
const repo = process.env.GITHUB_REPO;
const filePath = "test.txt"; // file to push
const branch = "main"; // or 'master'

// Read file content
const content = fs.readFileSync(filePath, "utf8");
const encodedContent = Buffer.from(content).toString("base64");

async function commitFile() {
  try {
    const { data: refData } = await octokit.git.getRef({ owner, repo, ref: `heads/${branch}` });
    const latestCommitSha = refData.object.sha;

    const { data: blobData } = await octokit.git.createBlob({
      owner,
      repo,
      content: encodedContent,
      encoding: "base64"
    });

    const { data: commitData } = await octokit.git.getCommit({ owner, repo, commit_sha: latestCommitSha });
    const baseTreeSha = commitData.tree.sha;

    const { data: newTree } = await octokit.git.createTree({
      owner,
      repo,
      base_tree: baseTreeSha,
      tree: [{ path: filePath, mode: "100644", type: "blob", sha: blobData.sha }]
    });

    const { data: newCommit } = await octokit.git.createCommit({
      owner,
      repo,
      message: `Automated update to ${filePath}`,
      tree: newTree.sha,
      parents: [latestCommitSha]
    });

    await octokit.git.updateRef({
      owner,
      repo,
      ref: `heads/${branch}`,
      sha: newCommit.sha
    });

    console.log(`✅ File ${filePath} committed successfully.`);
  } catch (err) {
    console.error("❌ Commit failed:", err.message);
  }
}

commitFile();
