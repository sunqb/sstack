import { createRequire } from "node:module";
import path from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const noTodoWithoutTicket = require("./eslint-rules/no-todo-without-ticket.js");
const root = path.dirname(fileURLToPath(import.meta.url));
void root;

export default [
  {
    ignores: ["node_modules/**", "dist/**", "build/**", "coverage/**"],
  },
  {
    files: ["**/*.{js,mjs,cjs,ts,tsx}"],
    plugins: {
      sstack: {
        rules: {
          "no-todo-without-ticket": noTodoWithoutTicket,
        },
      },
    },
    rules: {
      "sstack/no-todo-without-ticket": "error",
      "no-eval": "error",
      "no-new-func": "error",
      "no-restricted-syntax": [
        "error",
        {
          selector:
            "CallExpression[callee.object.name='child_process'][callee.property.name='exec']",
          message: "Do not call child_process.exec; use execFile or a typed wrapper.",
        },
      ],
      "no-restricted-imports": [
        "error",
        {
          patterns: [
            {
              group: ["**/infra/**", "**/infra"],
              message:
                "Adjust this boundary to your layout: app/ UI code should not import infra/ directly.",
            },
          ],
        },
      ],
    },
  },
];
