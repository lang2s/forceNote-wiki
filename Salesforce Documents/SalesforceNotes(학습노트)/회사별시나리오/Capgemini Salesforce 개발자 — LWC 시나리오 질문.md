---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Capgemini Salesforce Developer LWC]
---

# Capgemini Salesforce 개발자 — LWC 시나리오 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Q: Account의 Industry 선택 목록 값을 동적으로 가져오기
`lightning/uiObjectInfoApi`의 getPicklistValues 사용.
```javascript
import { LightningElement, track, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class IndustryPicklist extends LightningElement {
    @track industryOptions = [];
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT }) objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: INDUSTRY_FIELD })
    wiredPicklist({ error, data }) {
        if (data) {
            this.industryOptions = data.values.map(item => ({ label: item.label, value: item.value }));
        } else { console.error(error); }
    }
}
```
```html
<template>
    <lightning-combobox label="Industry" options={industryOptions}></lightning-combobox>
</template>
```
> 하드코딩 대신 메타데이터에서 동적 조회, 레코드 타입별 자동 적응.

## Q: 버튼 클릭으로 비밀번호 표시 토글
type="password"와 type="text" 동적 전환.
```javascript
import { LightningElement, track } from 'lwc';
export default class TogglePassword extends LightningElement {
    @track isPasswordVisible = false;
    togglePassword() { this.isPasswordVisible = !this.isPasswordVisible; }
}
```
```html
<template>
    <lightning-input type={isPasswordVisible ? 'text' : 'password'} label="Enter Password"></lightning-input>
    <lightning-button label="Show/Hide" onclick={togglePassword}></lightning-button>
</template>
```

## Q: 페이지네이션으로 대량 레코드 표시
Apex에서 LIMIT·OFFSET으로 조회, 페이지 번호·크기 유지.
```javascript
import { LightningElement, track } from 'lwc';
import getPaginatedAccounts from '@salesforce/apex/AccountController.getPaginatedAccounts';
export default class PaginatedList extends LightningElement {
    @track accounts = []; @track pageNumber = 1; @track pageSize = 5;
    @track totalRecords = 0; @track totalPages = 0;
    connectedCallback() { this.loadAccounts(); }
    loadAccounts() {
        getPaginatedAccounts({ pageNumber: this.pageNumber, pageSize: this.pageSize })
            .then(result => {
                this.accounts = result.accounts;
                this.totalRecords = result.totalRecords;
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            }).catch(error => console.error(error));
    }
    handlePrevious() { if (this.pageNumber > 1) { this.pageNumber--; this.loadAccounts(); } }
    handleNext() { if (this.pageNumber < this.totalPages) { this.pageNumber++; this.loadAccounts(); } }
}
```
```apex
public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static PaginatedResult getPaginatedAccounts(Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT :pageSize OFFSET :offset];
        Integer totalRecords = [SELECT COUNT() FROM Account];
        return new PaginatedResult(accounts, totalRecords);
    }
    public class PaginatedResult {
        @AuraEnabled public List<Account> accounts;
        @AuraEnabled public Integer totalRecords;
        public PaginatedResult(List<Account> accounts, Integer totalRecords) {
            this.accounts = accounts; this.totalRecords = totalRecords;
        }
    }
}
```
> OFFSET으로 레코드 건너뛰기, totalRecords·totalPages로 네비게이션.

## Q: 두 리스트 간 드래그앤드롭
네이티브 드래그앤드롭 이벤트(dragstart·dragover·drop).
```javascript
import { LightningElement, track } from 'lwc';
export default class DragDrop extends LightningElement {
    @track availableItems = [{id:'1',name:'Item 1'},{id:'2',name:'Item 2'},{id:'3',name:'Item 3'}];
    @track selectedItems = [];
    handleDragStart(event) { event.dataTransfer.setData("text/plain", event.target.dataset.id); }
    allowDrop(event) { event.preventDefault(); }
    handleDrop(event) {
        event.preventDefault();
        const itemId = event.dataTransfer.getData("text/plain");
        const item = this.availableItems.find(i => i.id === itemId);
        if (item) {
            this.selectedItems = [...this.selectedItems, item];
            this.availableItems = this.availableItems.filter(i => i.id !== itemId);
        }
    }
}
```
```html
<template>
    <div class="container">
        <div class="list">
            <h3>Available Items</h3>
            <template for:each={availableItems} for:item="item">
                <div key={item.id} class="item" draggable="true" ondragstart={handleDragStart} data-id={item.id}>
                    {item.name}
                </div>
            </template>
        </div>
        <div class="dropzone" ondragover={allowDrop} ondrop={handleDrop}>
            <h3>Selected Items</h3>
            <template for:each={selectedItems} for:item="item">
                <div key={item.id} class="item">{item.name}</div>
            </template>
        </div>
    </div>
</template>
```
