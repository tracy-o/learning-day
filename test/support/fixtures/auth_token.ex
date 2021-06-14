defmodule Fixtures.AuthToken do
  # Example auth values from
  # https://github.com/bbc/api-management-mybbc-id/blob/8d14619c4072f5d16e521f0e74a060b5fb277c13/src/test/common.js

  def authorised_user_access_token,
    do:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhNzZlYTQ3NS0xZjY3LTRiMjMtOTVhMi00NTJhMzY0ZTFhYTciLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.9GgmftJ-UzzU5WeJxN1YZ2c5ZAI708hlabt4yAgrAmk"

  def unauthorised_user_access_token,
    do:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

  def valid_access_token_without_user_attributes,
    do:
      "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIn0.WzhZPWnuPq8up5-GEhg9IYetYu0S_PPeZkEXld229KnnJY0iC1ZdVSnji3uOLMIPG9mSgBuBAQNnu3MjP6DFFQ"

  def invalid_scope_access_token,
    do:
      "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImludmFsaWQiXSwiYXV0aF90aW1lIjoxNTkwNTAyNzYwLCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MjEzODMsImlhdCI6MTU5MDYxNDE4MywiZXhwaXJlc19pbiI6MzEwOTA3MjAwLCJqdGkiOiJONkZoTVZwZ1VSeVNoWXV6SGdMc3hXN2w1ZEkifQ.LpefWTgxlskphUf_8S5b3t-s297ERITZ3vTamaEDsOKYWALhC8KcUm_L51YUCxCt1OdQQIJlobrh_fd-67Illg"

  def invalid_payload_access_token,
    do:
      "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuYXBpLmJiYy5jb20vYmJjaWR2NS9vYXV0aDIiLCJ0b2tlbk5hbWUiOiJhY2Nlc3NfdG9rZW4iLCJ0b2tlbl90eXBlIjoiQmVhcmVyIiwiYXV0aEdyYW50SWQiOiI1Z3J0YUVpZTR4XzFzM2c4NHI0RDB1cUtDTSIsImF1ZCI6IkFjY291bnQiLCJuYmYiOjE1OTA2MTQxODMsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwic2NvcGUiOlsiaW52YWxpZCJdLCJhdXRoX3RpbWUiOjE1OTA1MDI3NjAscmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIn0.kCiFOWqgFFeuEr2LIil5hAg-4H9Ic0T72oE_LaAO0ELIGocWY-3S7UG5gcrb6TSISOzmQBAlOTisC4SibOQdiA"

  def invalid_access_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuYXBpLmJiYy5jb20vYmJjaWR2NS9vYXV0aDIiLCJ0b2tlbk5hbWUiOiJhY2Nlc3NfdG9rZW4iLCJ0b2tlbl90eXBlIjoiQmVhcmVyIiwiYXV0aEdyYW50SWQiOiI1Z3J0YUVpZTR4XzFzM2c4NHI0RDB1cUtDTSIsImF1ZCI6IkFjY291bnQiLCJuYmYiOjE1OTA2MTQxODMsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwic2NvcGUiOlsiZXhwbGljaXQiLCJ1aWQiLCJpbXBsaWNpdCIsInBpaSIsImNvcmUiLCJvcGVuaWQiXSwiYXV0aF90aW1lIjoxNTkwNTAyNzYwLCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MjEzODMsImlhdCI6MTU5MDYxNDE4MywiZXhwaXJlc19pbiI6MzEwOTA3MjAwLCJqdGkiOiJONkZoTVZwZ1VSeVNoWXV6SGdMc3hXN2w1ZEkifQ.g5psKi13lZ8R_NAoEudQkHUejV6FJ1EaeMwyVyF37fsHAc9GLm9in1_djgy3uJjnTj_iFesi6VhQ2M-5apNQqt_DbzT5_aPSZiChGAtAbMqhKXaf7xV1Fj_UGvLOLs0C2C7Dg952gtWm96EwXjjl2npAwhfbVDq4FbKcR1ym7FE"

  def valid_identity_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiYmJpdlUyc3IzZ0Z3VjdoWFYtemNlZyIsInN1YiI6IjA4NGJiNjhkLTg2NjQtNGM1ZS1hMjNiLTZmNDMxYjU3ZDViMyIsImFiIjoibzE4IiwiYXVkaXRUcmFja2luZ0lkIjoiZDg2NmNlZGQtNmU0Zi00ZjUwLTk0MDEtZjYwMzNkOGE1Mjg4LTIxNiIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmludC5hcGkuYmJjLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImlkX3Rva2VuIiwiYXVkIjoidGVzdGNsaWVudDEiLCJjX2hhc2giOiJqbkM0YldiaWQ3UFFfLVJPNmN2ZEVRIiwiYWNyIjoiMCIsImF6cCI6InRlc3RjbGllbnQxIiwiYXV0aF90aW1lIjoxNTQxNTA2NTQ5LCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MDY1NjksInRva2VuVHlwZSI6IkpXVFRva2VuIiwiaWF0IjoxNTQxNTA2NTY5fQ.qpiulGBHnphQ5Lj0L9gPONfrQTWUaJjWw_2r4Al3R28V_M0HIoD_2RdOkaDZ2-spTVYWucEy30qFdlGhW4ce0iVOUY1dtX7EqLsKF-XsR5jCjuXU9-XMfLDK1fVilTON-06CLji1XJMZ0es3CfcgcDVkQAX1KQpx2hBPaNBn9E66mtbDgKQrD2Pg4jq5BJrL47C4XRbpPa8fnPL91V_tNepbClFnsNyhYX2HV1lwjJrPQg-P5fgb5Wbv7v8N6GexQjK38U574iVETeK9GKXiUKmfMgtMVp314XO9RtSRIrZjoSvA45GVRZjOZJBOQfCwGhb39wT8Ypf1lF-isWsP-w"

  def expired_access_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxMTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIn0.zMtd3iz2SbvT7A7vtk0DQox5vxEcdSRLe5WuIgCiWqY1ufCHQPTYknT3asmSdbbR91_46dYk8GPlMET8sMvTppPhmm18B8Jyi8QqJU8hYemQby5fnD4oSwntJlHVlMU3aXG6ZGev9paEI5Tr5jE3b3176PY_hhKUPumqV5XqGejZfijqZJbsN9JM_m0XPmWX2Ce9ieMSfGTqLFsxkUGYkx03bbuN_-ANxohN6RdJJWjt4UmpXBO75zsSJy7OUcJOUJDrBoaNVLkM5SQazMKY1m73_7R87pHQ43rOmlFwxYdeH0mJFDai9_uc36gyJPtLI1sBokFYVSPwZkTOOxfmuA"

  def expired_identity_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiYkQ3bndVTG83M3NhblUyVE1MenFndyIsInN1YiI6IjA4NGJiNjhkLTg2NjQtNGM1ZS1hMjNiLTZmNDMxYjU3ZDViMyIsImFiIjoibzE4IiwiYXVkaXRUcmFja2luZ0lkIjoiYjJmNmQ0ZDgtMDBkMS00ZGFkLWE1YWMtZmJhOThjYzA5Yjk0LTE5NSIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmludC5hcGkuYmJjLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImlkX3Rva2VuIiwiYXVkIjoidGVzdGNsaWVudDEiLCJjX2hhc2giOiI2aXJMbktWcUdvNVplVzUxWmt6N3FnIiwiYWNyIjoiMCIsImF6cCI6InRlc3RjbGllbnQxIiwiYXV0aF90aW1lIjoxNTQxNTA2NTQ5LCJyZWFsbSI6Ii8iLCJleHAiOjE1NDE1MDczMzcsInRva2VuVHlwZSI6IkpXVFRva2VuIiwiaWF0IjoxNTQxNTA3MzA3fQ.zMtd3iz2SbvT7A7vtk0DQox5vxEcdSRLe5WuIgCiWqY1ufCHQPTYknT3asmSdbbR91_46dYk8GPlMET8sMvTppPhmm18B8Jyi8QqJU8hYemQby5fnD4oSwntJlHVlMU3aXG6ZGev9paEI5Tr5jE3b3176PY_hhKUPumqV5XqGejZfijqZJbsN9JM_m0XPmWX2Ce9ieMSfGTqLFsxkUGYkx03bbuN_-ANxohN6RdJJWjt4UmpXBO75zsSJy7OUcJOUJDrBoaNVLkM5SQazMKY1m73_7R87pHQ43rOmlFwxYdeH0mJFDai9_uc36gyJPtLI1sBokFYVSPwZkTOOxfmuA"

  def invalid_signature_identity_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiYmJpdlUyc3IzZ0Z3VjdoWFYtemNlZyIsInN1YiI6IjA4NGJiNjhkLTg2NjQtNGM1ZS1hMjNiLTZmNDMxYjU3ZDViMyIsImFiIjoibzE4IiwiYXVkaXRUcmFja2luZ0lkIjoiZDg2NmNlZGQtNmU0Zi00ZjUwLTk0MDEtZjYwMzNkOGE1Mjg4LTIxNiIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmludC5hcGkuYmJjLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImlkX3Rva2VuIiwiYXVkIjoidGVzdGNsaWVudDEiLCJjX2hhc2giOiJqbkM0YldiaWQ3UFFfLVJPNmN2ZEVRIiwiYWNyIjoiMCIsImF6cCI6InRlc3RjbGllbnQxIiwiYXV0aF90aW1lIjoxNTQxNTA2NTQ5LCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MDY1NjksInRva2VuVHlwZSI6IkpXVFRva2VuIiwiaWF0IjoxNTQxNTA2NTY5fQ.qpiulGBHnphQ5Lj0L9gPONfrQTWUaJjWw_2r4Al3R28V_M0HIoD_2RdOkaDZ2-spTVYWucEy30qFdlGhW4ce0iVOUY1dtX7EqLsKF-XsR5jCjuXU9-XMfLDK1fVilTON-06CLji1XJMZ0es3CfcgcDVkQAX1KQpx2hBPaNBn9E66mtbDgKQrD2Pg4jq5BJrL47C4XRbpPa8fnPL91V_tNepbClFnsNyhYX2HV1lwjJrPQg-P5fgb5Wbv7v8N6Ge4QjK38U574iVETeK9GKXiUKmfMgtMVp314XO9RtSRIrZjoSvA45GVRZjOZJBOQfCwGhb39wT8Ypf1lF-isWsP-w"

  def invalid_signature_access_token,
    do:
      "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIn0.WzhZPWnuPq8up5-GEhg9IYetYu0S_PPeZkEXld229KnnJY0iC1ZdVSnji3uOLMIPG9mSgBuBAQNnu3MjP6DFF8"

  def invalid_token,
    do:
      "eyJ0ueXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiYkQ3bndVTG83M3NhblUyVE1MenFndyIsInN1YiI6IjA4NGJiNjhkLTg2NjQtNGM1ZS1hMjNiLTZmNDMxYjU3ZDViMyIsImFiIjoibzE4IiwiYXVkaXRUcmFja2luZ0lkIjoiYjJmNmQ0ZDgtMDBkMS00ZGFkLWE1YWMtZmJhOThjYzA5Yjk0LTE5NSIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmludC5hcGkuYmJjLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImlkX3Rva2VuIiwiYXVkIjoidGVzdGNsaWVudDEiLCJjX2hhc2giOiI2aXJMbktWcUdvNVplVzUxWmt6N3FnIiwiYWNyIjoiMCIsImF6cCI6InRlc3RjbGllbnQxIiwiYXV0aF90aW1lIjoxNTQxNTA2NTQ5LCJyZWFsbSI6Ii8iLCJleHAiOjE1NDE1MDczMzcsInRva2VuVHlwZSI6IkpXVFRva2VuIiwiaWF0IjoxNTQxNTA3MzA3fQ.zMtd3iz2SbvT7A7vtk0DQox5vxEcdSRLe5WuIgCiWqY1ufCHQPTYknT3asmSdbbR91_46dYk8GPlMET8sMvTppPhmm18B8Jyi8QqJU8hYemQby5fnD4oSwntJlHVlMU3aXG6ZGev9paEI5Tr5jE3b3176PY_hhKUPumqV5XqGejZfijqZJbsN9JM_m0XPmWX2Ce9ieMSfGTqLFsxkUGYkx03bbuN_-ANxohN6RdJJWjt4UmpXBO75zsSJy7OUcJOUJDrBoaNVLkM5SQazMKY1m73_7R87pHQ43rOmlFwxYdeH0mJFDai9_uc36gyJPtLI1sBokFYVSPwZkThOxfmuA"

  def invalid_key_token,
    do:
      "eyJ0eXAiOiJKV1QiLCJraWQiOiJ3dVUzaWZJSWFMT1VBUmVSQi9GRzZlTTFQMVFNPSIsImFsZyI6IkhTMjU2In0.eyJhdF9oYXNoIjoiYmJpdlUyc3IzZ0Z3VjdoWFYtemNlZyIsInN1YiI6IjA4NGJiNjhkLTg2NjQtNGM1ZS1hMjNiLTZmNDMxYjU3ZDViMyIsImFiIjoibzE4IiwiYXVkaXRUcmFja2luZ0lkIjoiZDg2NmNlZGQtNmU0Zi00ZjUwLTk0MDEtZjYwMzNkOGE1Mjg4LTIxNiIsImlzcyI6Imh0dHBzOi8vYWNjZXNzLmludC5hcGkuYmJjLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImlkX3Rva2VuIiwiYXVkIjoidGVzdGNsaWVudDEiLCJjX2hhc2giOiJqbkM0YldiaWQ3UFFfLVJPNmN2ZEVRIiwiYWNyIjoiMCIsImF6cCI6InRlc3RjbGllbnQxIiwiYXV0aF90aW1lIjoxNTQxNTA2NTQ5LCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MDY1NjksInRva2VuVHlwZSI6IkpXVFRva2VuIiwiaWF0IjoxNTQxNTA2NTY5fQ.g93JSqUecqVtyzzzZWK116WmdKjKZ1stIMQxx-Y4JXI"

  def invalid_access_token_header,
    do: Joken.Signer.sign(%{"name" => "John Doe"}, Joken.Signer.create("HS256", "secret")) |> elem(1)

  def malformed_access_token, do: "abcdef"

  def invalid_token_issuer do
    "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5ldmlsLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImFjY2Vzc190b2tlbiIsInRva2VuX3R5cGUiOiJCZWFyZXIiLCJhdXRoR3JhbnRJZCI6IjVncnRhRWllNHhfMXMzZzg0cjREMHVxS0NNIiwiYXVkIjoiQWNjb3VudCIsIm5iZiI6MTU5MDYxNDE4MywiZ3JhbnRfdHlwZSI6InJlZnJlc2hfdG9rZW4iLCJzY29wZSI6WyJleHBsaWNpdCIsInVpZCIsImltcGxpY2l0IiwicGlpIiwiY29yZSIsIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE1OTA1MDI3NjAsInJlYWxtIjoiLyIsImV4cCI6MTkwMTUyMTM4MywiaWF0IjoxNTkwNjE0MTgzLCJleHBpcmVzX2luIjozMTA5MDcyMDAsImp0aSI6Ik42RmhNVnBnVVJ5U2hZdXpIZ0xzeFc3bDVkSSJ9.hfa22z8KLPOXsWCfCpFHf9YCqYLEoRHFbdIDhWsTz8k-c8QWEDect6EnB_RwHW-Zh4-msJiwxCMy-TQ8ZZDxCw"
  end

  def invalid_token_aud do
    "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5ldmlsLmNvbS9iYmNpZHY1L29hdXRoMiIsInRva2VuTmFtZSI6ImFjY2Vzc190b2tlbiIsInRva2VuX3R5cGUiOiJCZWFyZXIiLCJhdXRoR3JhbnRJZCI6IjVncnRhRWllNHhfMXMzZzg0cjREMHVxS0NNIiwiYXVkIjoiT3RoZXIiLCJuYmYiOjE1OTA2MTQxODMsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwic2NvcGUiOlsiZXhwbGljaXQiLCJ1aWQiLCJpbXBsaWNpdCIsInBpaSIsImNvcmUiLCJvcGVuaWQiXSwiYXV0aF90aW1lIjoxNTkwNTAyNzYwLCJyZWFsbSI6Ii8iLCJleHAiOjE5MDE1MjEzODMsImlhdCI6MTU5MDYxNDE4MywiZXhwaXJlc19pbiI6MzEwOTA3MjAwLCJqdGkiOiJONkZoTVZwZ1VSeVNoWXV6SGdMc3hXN2w1ZEkifQ.tKVHJYtlt998cW6LSt8XMZmC7XzCp5wF7xjSc7f7q4uSUsA7Q3FG069ZqO3Fvmgmd8AP58w0ejEnD3MYOLcoSQ"
  end

  def invalid_token_name do
    "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiSU5WQUxJRCIsInRva2VuX3R5cGUiOiJCZWFyZXIiLCJhdXRoR3JhbnRJZCI6IjVncnRhRWllNHhfMXMzZzg0cjREMHVxS0NNIiwiYXVkIjoiQWNjb3VudCIsIm5iZiI6MTU5MDYxNDE4MywiZ3JhbnRfdHlwZSI6InJlZnJlc2hfdG9rZW4iLCJzY29wZSI6WyJleHBsaWNpdCIsInVpZCIsImltcGxpY2l0IiwicGlpIiwiY29yZSIsIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE1OTA1MDI3NjAsInJlYWxtIjoiLyIsImV4cCI6MTkwMTUyMTM4MywiaWF0IjoxNTkwNjE0MTgzLCJleHBpcmVzX2luIjozMTA5MDcyMDAsImp0aSI6Ik42RmhNVnBnVVJ5U2hZdXpIZ0xzeFc3bDVkSSJ9.u-qZDrfbQal6sO1Jnz-YT3oQKsUEurMb_1XUS865AgWlvLrL574g8nFNq8YTQtFnSg6pXPvYMNOxV9iskS14MA"
  end

  def valid_access_token do
    "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIiwidXNlckF0dHJpYnV0ZXMiOnsiYWdlQnJhY2tldCI6Im8xOCIsImFsbG93UGVyc29uYWxpc2F0aW9uIjp0cnVlLCJhbmFseXRpY3NIYXNoZWRJZCI6ImdKT0YtOWFJUTYwaVpJcFlhRXlTUVAwSU1JMmdBcmZVVEZMay1sZ0VHVEUifX0.xg4vY41q6X9XlejwUX_8MGADWigvd_xj-wMEn8rnnwaV3FxWhE2gb9NVX3gMEjZJUw4CSwq_-ajd8hhUNXmChw"
  end

  def keys,
    do: [
      %{
        "kty" => "EC",
        "kid" => "SOME_EC_KEY_ID",
        "crv" => "P-256",
        "x" => "EVs_o5-uQbTjL3chynL4wXgUg2R9q9UU8I5mEovUf84",
        "y" => "kGe5DgSIycKp8w9aJmoHhB1sB3QTugfnRWm5nU_TzsY",
        "alg" => "ES256",
        "use" => "sig"
      },
      %{
        "kty" => "RSA",
        "kid" => "SOMERANDOM",
        "n" =>
          "sgftzuGUjJ16GhgOwKMTos5AaFyj_7-nMmqF0m2zJWtYTpOmn8sCDM3RT4bLAVE2GMbaPvldDZdsbGO0VdWWfDrviLzKWUX_mi9PfSjdNmEbyzcGSv7FI3vdYcRjxhYogPK1ngMwM-UKDVgJAv478UIg80e7LRiIRT5H5Qk_jJ8",
        "e" => "AQAB"
      },
      %{
        "kty" => "RSA",
        "kid" => "0ccd7c65-ff20-4500-8742-5da72ef4af67",
        "alg" => "RS256",
        "use" => "enc"
      },
      %{
        "kty" => "RSA",
        "kid" => "wU3ifIIaLOUAReRB/FG6eM1P1QM=",
        "use" => "sig",
        "x5t" => "5eOfy1Nn2MMIKVRRkq0OgFAw348",
        "x5c" => [
          "MIIDdzCCAl+gAwIBAgIES3eb+zANBgkqhkiG9w0BAQsFADBsMRAwDgYDVQQGEwdVbmtub3duMRAwDgYDVQQIEwdVbmtub3duMRAwDgYDVQQHEwdVbmtub3duMRAwDgYDVQQKEwdVbmtub3duMRAwDgYDVQQLEwdVbmtub3duMRAwDgYDVQQDEwdVbmtub3duMB4XDTE2MDUyNDEzNDEzN1oXDTI2MDUyMjEzNDEzN1owbDEQMA4GA1UEBhMHVW5rbm93bjEQMA4GA1UECBMHVW5rbm93bjEQMA4GA1UEBxMHVW5rbm93bjEQMA4GA1UEChMHVW5rbm93bjEQMA4GA1UECxMHVW5rbm93bjEQMA4GA1UEAxMHVW5rbm93bjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANdIhkOZeSHagT9ZecG+QQwWaUsi7OMv1JvpBr/7HtAZEZMDGWrxg/zao6vMd/nyjSOOZ1OxOwjgIfII5+iwl37oOexEH4tIDoCoToVXC5iqiBFz5qnmoLzJ3bF1iMupPFjz8Ac0pDeTwyygVyhv19QcFbzhPdu+p68epSatwoDW5ohIoaLzbf+oOaQsYkmqyJNrmht091XuoVCazNFt+UJqqzTPay95Wj4F7Qrs+LCSTd6xp0Kv9uWG1GsFvS9TE1W6isVosjeVm16FlIPLaNQ4aEJ18w8piDIRWuOTUy4cbXR/Qg6a11l1gWls6PJiBXrOciOACVuGUoNTzztlCUkCAwEAAaMhMB8wHQYDVR0OBBYEFMm4/1hF4WEPYS5gMXRmmH0gs6XjMA0GCSqGSIb3DQEBCwUAA4IBAQDVH/Md9lCQWxbSbie5lPdPLB72F4831glHlaqms7kzAM6IhRjXmd0QTYq3Ey1J88KSDf8A0HUZefhudnFaHmtxFv0SF5VdMUY14bJ9UsxJ5f4oP4CVh57fHK0w+EaKGGIw6TQEkL5L/+5QZZAywKgPz67A3o+uk45aKpF3GaNWjGRWEPqcGkyQ0sIC2o7FUTV+MV1KHDRuBgreRCEpqMoY5XGXe/IJc1EJLFDnsjIOQU1rrUzfM+WP/DigEQTPpkKWHJpouP+LLrGRj2ziYVbBDveP8KtHvLFsnexA/TidjOOxChKSLT9LYFyQqsvUyCagBb4aLs009kbW6inN8zA6"
        ],
        "n" =>
          "10iGQ5l5IdqBP1l5wb5BDBZpSyLs4y_Um-kGv_se0BkRkwMZavGD_Nqjq8x3-fKNI45nU7E7COAh8gjn6LCXfug57EQfi0gOgKhOhVcLmKqIEXPmqeagvMndsXWIy6k8WPPwBzSkN5PDLKBXKG_X1BwVvOE9276nrx6lJq3CgNbmiEihovNt_6g5pCxiSarIk2uaG3T3Ve6hUJrM0W35QmqrNM9rL3laPgXtCuz4sJJN3rGnQq_25YbUawW9L1MTVbqKxWiyN5WbXoWUg8to1DhoQnXzDymIMhFa45NTLhxtdH9CDprXWXWBaWzo8mIFes5yI4AJW4ZSg1PPO2UJSQ",
        "e" => "AQAB",
        "alg" => "RS256"
      }
    ]
end
