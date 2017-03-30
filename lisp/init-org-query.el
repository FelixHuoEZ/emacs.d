;;; init-org-query

(add-to-list 'load-path "~/.emacs.d/site-lisp/org-query/")

(require 'org-habit)
(require 'org-query-gtd)

(defun rmh/agendablock-tasks-waiting ()
  `(tags-todo "/+WAITING|+DEFERRED"
              ((org-agenda-overriding-header "Tasks waiting for something")
               (org-tags-match-list-sublevels nil)
               (org-agenda-skip-function (org-query-select "headline" (not (org-query-gtd-project))))
               (org-agenda-todo-ignore-scheduled t)
               (org-agenda-todo-ignore-deadlines t)
               )))

(defun rmh/agendablock-next-in-active ()
  `(tags-todo "/+NEXT"
              ((org-agenda-overriding-header "Next tasks in active projects")
               (org-agenda-skip-function (org-query-select "headline" (org-query-gtd-active-project-next-task)))
               (org-tags-match-list-sublevels t)
               (org-agenda-todo-ignore-scheduled 't)
               (org-agenda-todo-ignore-deadlines 't)
               (org-agenda-todo-ignore-with-date 't)
               (org-agenda-sorting-strategy
                '(todo-state-down effort-up category-keep)))))

(defun rmh/agendablock-backlog-of-active ()
  `(tags-todo "/+TODO"
              ((org-agenda-overriding-header "Backlog of active projects")
               (org-agenda-skip-function (org-query-select "headline" (org-query-gtd-backlog-task)))
               (org-agenda-todo-ignore-scheduled 't)
               (org-agenda-todo-ignore-deadlines 't)
               (org-agenda-todo-ignore-with-date 't)
               (org-agenda-sorting-strategy
                '(category-keep)))))

(defun rmh/agendablock-active-projects-without-next ()
  `(tags-todo "/+NEXT"
              ((org-agenda-overriding-header "Active projects without next task")
               (org-agenda-skip-function (org-query-select "tree" (org-query-gtd-active-project-stuck)))
               (org-tags-match-list-sublevels 't)
               (org-agenda-sorting-strategy
                '(category-keep)))))

(defun rmh/agendablock-active-projects-with-next ()
  `(tags-todo "/+NEXT"
              ((org-agenda-overriding-header "Active projects with a next task")
               (org-agenda-skip-function (org-query-select "tree" (org-query-gtd-active-project-armed)))
               (org-tags-match-list-sublevels 't)
               (org-agenda-sorting-strategy
                '(category-keep)))))

(defun rmh/agendablock-waiting-projects ()
  `(tags-todo "/+WAITING"
              ((org-agenda-overriding-header "Waiting projects")
               (org-agenda-skip-function (org-query-select "tree" (org-query-gtd-project)))
               (org-tags-match-list-sublevels 't)
               (org-agenda-sorting-strategy
                '(category-keep)))))

(defun rmh/agendablock-loose-tasks ()
  `(tags-todo "/+TODO"
              ((org-agenda-overriding-header "Tasks not belonging to a project")
               (org-agenda-skip-function
                (org-query-select "headline" (and (org-query-gtd-loose-task) (not (org-is-habit-p)))))
               (org-agenda-todo-ignore-scheduled 't)
               (org-agenda-todo-ignore-deadlines 't)
               (org-agenda-todo-ignore-with-date 't)
               (org-agenda-sorting-strategy
                '(category-keep)))))

(defun rmh/agendablock-checklists ()
  `(tags "CHECKLIST"
         ((org-agenda-overriding-header "Checklists")
          (org-tags-match-list-sublevels nil))))

(defun rmh/agendablock-inbox ()
  `(tags-todo "LEVEL=2"
              ((org-agenda-overriding-header "Tasks to refile")
               (org-agenda-skip-function (org-query-select "tree" (org-query-gtd-refile)))
               (org-tags-match-list-sublevels nil))))


(setq org-agenda-custom-commands
      `((" " "Agenda"
         ((agenda "" ((org-agenda-ndays 1)))
          ,(rmh/agendablock-inbox)
          ,(rmh/agendablock-tasks-waiting)
          ,(rmh/agendablock-next-in-active)
          ,(rmh/agendablock-active-projects-with-next)
          ,(rmh/agendablock-active-projects-without-next)
          ,(rmh/agendablock-waiting-projects)
          ,(rmh/agendablock-backlog-of-active)
          ,(rmh/agendablock-checklists))
         nil)
        ("r" "Review Agenda"
         ((agenda "" ((org-agenda-ndays 1)))
          ,(rmh/agendablock-inbox)
          ,(rmh/agendablock-loose-tasks)
          ,(rmh/agendablock-tasks-waiting)
          ,(rmh/agendablock-next-in-active)
          ,(rmh/agendablock-active-projects-with-next)
          ,(rmh/agendablock-active-projects-without-next)
          ,(rmh/agendablock-backlog-of-active)
          ,(rmh/agendablock-checklists))
         nil)))

(provide 'init-org-query)

;;; init-org-query.el ends here
