# LWC의 Bubble·Capture 단계

이벤트 발생 시 DOM을 따라 전파된다. 전파는 두 단계: 이벤트 버블링·이벤트 캡처링.

## Bubble Phase
컴포넌트를 따라 위로(아래→위) 전파되는 이벤트가 Bubble Phase. (파란 화살표: 아래에서 위)

## Capture Phase
컴포넌트를 따라 아래로(위→아래) 전파되는 이벤트가 Capture Phase. (빨간 화살표: 위에서 아래)

> Bubble·Capture 단계를 통해 LWC의 이벤트 처리를 이해할 수 있다. (원본에는 childComp·parentComponent의 html·js 코드 예제가 포함되어 있습니다.)
