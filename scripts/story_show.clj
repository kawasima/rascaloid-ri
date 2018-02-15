(control/defroute ["project/" :projectId "/story/" :storyId] :get
  (api/call-api [{:id :rascaloid_api
                  :path "/story/{storyId}"
                  :method :get
                  :var "story"}
                 {:id :rascaloid_api
                  :method :get
                  :path "/story/{storyId}/tasks/byStatus"
                  :var "tasks"}
                 {:id :rascaloid_api
                  :path "/project/{projectId}"
                  :method :get
                  :var "project"}
                 {:id :rascaloid_api
                  :path "/taskStatus"
                  :method :get
                  :var "taskStatus"}])
  (control/if-success
   (renderer/render {:template "story/show.ftl"})
   (renderer/render {:template "error.ftl"})))
