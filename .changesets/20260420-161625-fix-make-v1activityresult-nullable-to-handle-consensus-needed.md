---
title: "fix: make v1Activity.result nullable to handle CONSENSUS_NEEDED"
date: "2026-04-20"
packages:
  turnkey_http: "minor"
  turnkey_sdk_flutter: "patch"
---

v1Activity.result is now typed v1Result? instead of v1Result. The Turnkey API omits the result field when an activity is pending consensus approval (ACTIVITY_STATUS_CONSENSUS_NEEDED), which previously caused a runtime null-cast crash. 

