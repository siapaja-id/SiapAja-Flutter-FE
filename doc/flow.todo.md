
3a70b19 refactor: split PostDetail page into focused components Extract EmptyRepliesState, BidSheet, CompletionSheet, ReviewSheet, and TaskActionFooter into separate files under post-detail/ directory. Deduplicate handleSendReply into a single function. Remove unused useMemo import. The page is now ~200 lines down from ~400+.

===

this flutter project is basically ported version of react https://github.com/siapaja-id/SiapAja-React-FE so please temporarily clone it to learn bellow git commit.

95d9f54 feat: add settings page and improve UI components across feed, gigs, and profile 

. 


because you need to do the same treatment to this flutter project. we want identical UI UX without regressions