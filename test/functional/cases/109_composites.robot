*** Settings ***
Suite Setup     Generic Setup
Suite Teardown  Simple Teardown
Library         ${TESTDIR}/lib/rspamd.py
Resource        ${TESTDIR}/lib/rspamd.robot
Variables       ${TESTDIR}/lib/vars.py

*** Variables ***
${CONFIG}       ${TESTDIR}/configs/composites.conf
${LUA_SCRIPT}   ${TESTDIR}/lua/composites.lua
${MESSAGE}      ${TESTDIR}/messages/spam_message.eml
${RSPAMD_SCOPE}  Suite

*** Test Cases ***
Composites - Score
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  ${SPACE}46.00 / 0.00

Composites - Expressions
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  EXPRESSIONS (5.00)
  Should Contain  ${result.stdout}  EXPRESSIONS_B (0.00)

Composites - Policy: remove_weight
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  ${SPACE}POLICY_REMOVE_WEIGHT (5.00)
  Should Not Contain  ${result.stdout}  ${SPACE}POLICY_REMOVE_WEIGHT_A (1.00)
  Should Contain  ${result.stdout}  ${SPACE}POLICY_REMOVE_WEIGHT_B (0.00)

Composites - Policy: force removing
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  ${SPACE}POLICY_FORCE_REMOVE (5.00)
  Should Contain  ${result.stdout}  ${SPACE}POLICY_FORCE_REMOVE_A (1.00)
  Should Not Contain  ${result.stdout}  ${SPACE}POLICY_FORCE_REMOVE_B

Composites - Policy: leave
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  ${SPACE}POLICY_LEAVE (5.00)
  Should Not Contain  ${result.stdout}  ${SPACE}POLICY_LEAVE_A
  Should Contain  ${result.stdout}  ${SPACE}POLICY_LEAVE_B (1.00)

Composites - Default policy: remove_weight
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  DEFAULT_POLICY_REMOVE_WEIGHT (5.00)
  Should Contain  ${result.stdout}  DEFAULT_POLICY_REMOVE_WEIGHT_A (0.00)
  Should Contain  ${result.stdout}  DEFAULT_POLICY_REMOVE_WEIGHT_B (0.00)

Composites - Default policy: remove_symbol
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  DEFAULT_POLICY_REMOVE_SYMBOL (5.00)
  Should Not Contain  ${result.stdout}  DEFAULT_POLICY_REMOVE_SYMBOL_

Composites - Default policy: leave
  ${result} =  Scan Message With Rspamc  ${MESSAGE}
  Check Rspamc  ${result}  DEFAULT_POLICY_LEAVE (5.00)
  Should Contain  ${result.stdout}  DEFAULT_POLICY_LEAVE_A (1.00)
  Should Contain  ${result.stdout}  DEFAULT_POLICY_LEAVE_B (1.00)
