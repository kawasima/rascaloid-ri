<#import "../layout.ftl" as layout>
<@layout.layout>
    <style>
     /* Board */

     .board {
         position: relative;
         margin-left: 1%;
     }
     .board-column {
         position: absolute;
         left: 0;
         right: 0;
         width: 30%;
         margin: 0 1.5%;
         background: #f0f0f0;
         border-radius: 3px;
         z-index: 1;
     }
     .board-column.muuri-item-releasing {
         z-index: 2;
     }
     .board-column.muuri-item-dragging {
         z-index: 3;
         cursor: move;
     }
     .board-column-header {
         position: relative;
         height: 50px;
         line-height: 50px;
         overflow: hidden;
         padding: 0 20px;
         text-align: center;
         background: #333;
         color: #fff;
         border-radius: 3px 3px 0 0;
     }
     @media (max-width: 600px) {
         .board-column-header {
             text-indent: -1000px;
         }
     }
     .board-column.todo .board-column-header {
         background: #4A9FF9;
     }
     .board-column.working .board-column-header {
         background: #f9944a;
     }
     .board-column.done .board-column-header {
         background: #2ac06d;
     }
     .board-column-content {
         position: relative;
         border: 10px solid transparent;
         min-height: 95px;
     }
     .board-item {
         position: absolute;
         width: 100%;
         margin: 5px 0;
     }
     .board-item.muuri-item-releasing {
         z-index: 9998;
     }
     .board-item.muuri-item-dragging {
         z-index: 9999;
         cursor: move;
     }
     .board-item.muuri-item-hidden {
         z-index: 0;
     }
     @media (max-width: 600px) {
         .board-item-content {
             text-align: center;
         }
         .board-item-content span {
             display: none;
         }
     }
    </style>

    <h1>Story: ${story.subject} / Project: <a href="/project/${project.id}">${project.name}</a></h1>


    <h2>Tasks</h2>

    <div class="kanban">
        <div class="board">
            <#list taskStatus as state>
                <div class="board-column todo">
                    <div class="board-column-header">${state.name}</div>
                    <div class="board-column-content">
                        <#if tasks?api.containsKey(state.id?string)>
                            <#list tasks?api.get(state.id?string)>
                                <#items as task>
                                    <div class="board-item card">
                                        <div class="board-item-content card-body">
                                            <h5 class="card-title">#${task.id} ${task.subject}</h5>
                                            <p class="card-text">${task.description}</p>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item">${task.estimatedHours}h</li>
                                            </ul>
                                            <div class="card-body">
                                                <a class="card-link" href="/project/${project.id}/story/${story.id}/task/${task.id}/edit">Edit</a>
                                                <a class="card-link" href="/project/${project.id}/story/${story.id}/task/${task.id}/edit">Delete</a>
                                            </div>
                                        </div>
                                    </div>
                                </#items>
                            </#list>
                        </#if>
                    </div>
                </div>
            </#list>
        </div>
    </div>
    <a href="/project/${project.id}/story/${story.id}/tasks/new">New Task</a>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/web-animations/2.3.1/web-animations.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/hammer.js/2.0.8/hammer.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/muuri/0.5.3/muuri.min.js"></script>
    <script>
     document.addEventListener('DOMContentLoaded', function () {

         var docElem = document.documentElement;
         var kanban = document.querySelector('.kanban');
         var board = kanban.querySelector('.board');
         var itemContainers = Array.prototype.slice.call(kanban.querySelectorAll('.board-column-content'));
         var columnGrids = [];
         var dragCounter = 0;
         var boardGrid;

         itemContainers.forEach(function (container) {

             var muuri = new Muuri(container, {
                 items: '.board-item',
                 layoutDuration: 400,
                 layoutEasing: 'ease',
                 dragEnabled: true,
                 dragSort: function () {
                     return columnGrids;
                 },
                 dragSortInterval: 0,
                 dragContainer: document.body,
                 dragReleaseDuration: 400,
                 dragReleaseEasing: 'ease'
             })
                 .on('dragStart', function (item) {
      ++dragCounter;
                     docElem.classList.add('dragging');
                     item.getElement().style.width = item.getWidth() + 'px';
                     item.getElement().style.height = item.getHeight() + 'px';
                 })
                 .on('dragEnd', function (item) {
                     if (--dragCounter < 1) {
                         docElem.classList.remove('dragging');
                     }
                 })
                 .on('dragReleaseEnd', function (item) {
                     item.getElement().style.width = '';
                     item.getElement().style.height = '';
                     columnGrids.forEach(function (muuri) {
                         muuri.refreshItems();
                     });
                 })
                 .on('layoutStart', function () {
                     boardGrid.refreshItems().layout();
                 });

             columnGrids.push(muuri);

         });

         boardGrid = new Muuri(board, {
             layoutDuration: 400,
             layoutEasing: 'ease',
             dragEnabled: true,
             dragSortInterval: 0,
             dragStartPredicate: {
                 handle: '.board-column-header'
             },
             dragReleaseDuration: 400,
             dragReleaseEasing: 'ease'
         });

     });
    </script>
</@layout.layout>
