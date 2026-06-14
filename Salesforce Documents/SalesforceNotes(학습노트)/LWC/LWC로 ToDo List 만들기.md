---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [To Do List In LWC]
---

# LWC로 ToDo List 만들기

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## HTML
```html
<template>
    <lightning-card title="ToDoList">
        <div class="slds-var-m-around_medium">
            <template lwc:if={displayvalue}>
                <template for:each={tasklist} for:item="upcomingtask">
                    <div key={upcomingtask.taskId} class="slds-var-m-around_medium">
                        <b>{upcomingtask.name}</b>
                        <lightning-button-icon name={upcomingtask.taskId} icon-name="utility:delete"
                            title="Delete" onclick={deleteclick}></lightning-button-icon>
                    </div>
                </template>
            </template>
            <template lwc:else>
                <b>No more task today</b>
            </template>
            <div>
                <lightning-input label="Enter the task" onchange={handlechange} class="kumar"></lightning-input>
                <lightning-button label="Add Task" onclick={handleclick} variant="brand"></lightning-button>
            </div>
        </div>
    </lightning-card>
</template>
```

## JS
```javascript
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Todolist extends LightningElement {
    @track tasklist = [];
    newtask;

    handlechange(event) {
        this.newtask = event.target.value;
    }
    handleclick() {
        let Uniqueid = this.tasklist.length + 1;  // 길이를 task id로 사용
        let taskobj = { taskId: Uniqueid, name: this.newtask };
        this.tasklist = [...this.tasklist, taskobj];  // 스프레드 연산자로 기존+신규
        this.template.querySelector(".kumar").value = '';
    }
    deleteclick(event) {
        let iconId = event.target.name;
        this.tasklist = this.tasklist.filter(curTask => curTask.taskId !== iconId);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Task Deleted', message: 'Task Deleted Successfully', variant: 'success'
        }));
    }
    get displayvalue() {
        return this.tasklist.length > 0;
    }
}
```
