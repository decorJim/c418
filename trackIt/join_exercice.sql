USE TrackIt;

SELECT * FROM TaskStatus
WHERE IsResolved = 1;

SELECT * FROM Task 
WHERE TaskStatusId BETWEEN 5 AND 8;

SELECT * FROM Task
WHERE TaskStatusId IN(
	SELECT TaskStatusId FROM Task
    WHERE TaskStatusId = 1
);

# named using alias for tables
SELECT TaskId, Title, `Name` FROM TaskStatus ts
JOIN Task t ON ts.TaskStatusId = t.TaskStatusId;

# no duplicate of each column TaskStatusId that might crash outer queries
SELECT TaskId, Title, `Name` FROM TaskStatus 
JOIN Task USING(TaskStatusId);

SELECT
  Project.Name,
  Worker.FirstName,
  Worker.LastName
FROM Project
INNER JOIN ProjectWorker ON Project.ProjectId = ProjectWorker.ProjectId
INNER JOIN Worker ON ProjectWorker.WorkerId = Worker.WorkerId
WHERE Project.ProjectId = 'game-goodboy';

SELECT
  Project.Name,
  Worker.FirstName,
  Worker.LastName,
  Task.Title
FROM Project
INNER JOIN ProjectWorker ON Project.ProjectId = ProjectWorker.ProjectId
INNER JOIN Worker ON ProjectWorker.WorkerId = Worker.WorkerId
INNER JOIN Task ON ProjectWorker.ProjectId = Task.ProjectId
  AND ProjectWorker.WorkerId = Task.WorkerId
WHERE Project.ProjectId = 'game-goodboy';


SELECT * FROM Task;

SELECT *
FROM Task
INNER JOIN TaskStatus ON Task.TaskStatusId = TaskStatus.TaskStatusId;

SELECT * FROM Task
WHERE TaskStatusId IS NULL;

SELECT Task.TaskId, Task.Title,
	IFNULL(Task.TaskStatusId, 0) AS TaskStatusId, IFNULL(TaskStatus.Name,'[None]') AS StatusName
FROM Task
LEFT OUTER JOIN TaskStatus ON Task.TaskStatusId = TaskStatus.TaskStatusId;

SELECT Project.Name ProjectName FROM Project 
LEFT OUTER JOIN ProjectWorker ON Project.ProjectId = ProjectWorker.ProjectId
WHERE ProjectWorker.WorkerId IS NULL;

SELECT * FROM Worker w
LEFT JOIN ProjectWorker pw USING(WorkerId);

# Parent Child JOIN
SELECT parent.TaskId parentTaskId, child.TaskId childTaskId, CONCAT(parent.title,':',child.title)
FROM Task parent JOIN Task child
ON parent.TaskId = child.ParentTaskId;







