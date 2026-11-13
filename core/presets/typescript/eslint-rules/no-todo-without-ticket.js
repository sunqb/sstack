/** Ban TODO/FIXME comments that do not mention a ticket id (e.g. ABC-123 or #456). */
module.exports = {
  meta: {
    type: "problem",
    docs: {
      description: "Disallow TODO/FIXME comments unless they include a ticket id",
    },
    schema: [],
    messages: {
      missingTicket:
        "TODO/FIXME must include a ticket id (ABC-123 or #123). Do not leave an untracked note.",
    },
  },
  create(context) {
    const ticket = /(?:[A-Z]{2,}-\d+|#\d+)/;
    const marker = /\b(?:TODO|FIXME)\b/;
    return {
      Program() {
        const source = context.sourceCode ?? context.getSourceCode();
        for (const comment of source.getAllComments()) {
          if (marker.test(comment.value) && !ticket.test(comment.value)) {
            context.report({ loc: comment.loc, messageId: "missingTicket" });
          }
        }
      },
    };
  },
};
