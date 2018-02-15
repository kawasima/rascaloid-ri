<#import "../layout.ftl" as layout>
<@layout.layout>
    <h1>Iteration: ${iteration.subject} / Project: <a href="/project/${project.id}">${project.name}</a></h1>

    <p>Duration: ${iteration.startOn} - ${iteration.endOn}</p>
    <a href="/project/${project.id}/stories/new?iterationId=${iteration.id}">New Story</a>

</@layout.layout>
