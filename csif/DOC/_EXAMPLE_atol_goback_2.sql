{
   "type": "object",
   "properties": {
            "uuid": {
                      "type": "string"
            },
            "error": {
                        "type": [
                                   "object",
                                   "null"
                                ],
                        "properties": {
                                        "error_id": {
                                                      "type": "string"
                                        },
                                        "code": {
                                                  "type": "integer"
                                        },
                                        "text": {
                                                  "type": "string"
                                        },
                                        "type": {
                                        "type": "string",
                                        "enum": [
                                                  "none",
                                                  "unknown",
                                                  "system",
                                                  "driver",
                                                  "timeout",
                                                  "agent"
                                                ]
                                        }
                        },
                        "required": [
                                       "code",
                                       "text",
                                       "error_id"
                        ]
            },
            "timestamp": {
                             "type": "string"
            },
            "status": {
                        "type": "string",
                        "enum": [
                                   "wait",
                                   "done",
                                   "fail"
                        ]
            },
            "group_code": {
                             "type": "string"
            },
            "daemon_code": {
                             "type": "string"
            },
            "device_code": {
                             "type": "string"
            },
            "callback_url": {
                              "type": "string"
            },
            "payload": {
                          "type": "null"
            }
   },
   --
   "required": [
                 "error",
                 "timestamp"
   ]
}
