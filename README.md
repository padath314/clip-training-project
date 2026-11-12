<img width="786" height="312" alt="Screenshot 2026-11-06 at 4 58 06 PM" src="https://github.com/user-attachments/assets/97c412ae-26a2-4eb2-bc78-149d0746d288" />

Both of you write your own contribution statement, and each should be specific, since a vague one gets zero.

Leaner run matrix (6 runs)
CLIP, AdamW (baseline)
SogCLR, AdamW
iSogCLR, AdamW
Best loss, 2nd optimizer
Best loss, 3rd optimizer (optional)
Novel idea, best optimizer

That’s the minimum (3 losses, 2 optimizers) plus one run for novelty and one optional extra.

Adjusted 3-week schedule

Week 1 (Nov 6–12): baselines

Both: Get the Colab codebase running on a tiny subset. Confirm both evaluations work.
A: Start the CLIP baseline run by Mon, then SogCLR. B: Write the eval scripts and result logging, then start iSogCLR on a second GPU or session if you can get one.
Thu: Both check baseline numbers and loss curves.

Week 2 (Nov 13–19): comparisons and novelty

A: Runs 4–5 (optimizers). B: Design and test the novel idea on a short run, then launch run 6.
Run the long jobs overnight and do the code and writing work during the day.
Thu: Freeze experiments.

Week 3 (Nov 20–26): writing and submission

Fri–Sun: Draft the report sections in parallel, then swap and proofread each other’s.
Mon–Tue: Finalize the model choice, record and edit the video.
Wed: Check that the checkpoint loads in a fresh environment and the report meets the page requirement.
Thu: Submit, with Wed as a buffer.

Two-person tips
- Whoever has less GPU access should take the writing-heavy tasks early, then switch to run monitoring.
- With only 2 people, the 30-epoch runs are your real constraint. If you can only afford about 5 runs, drop the optional optimizer run first and keep the novelty run.
- Use the shared GitHub repo for code and a shared doc for the report and results table, so neither of you blocks the other.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
