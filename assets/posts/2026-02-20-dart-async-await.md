---
title: Dart async/await 완벽 이해하기
date: 2026-02-20
description: Dart의 비동기 프로그래밍 패턴인 Future, async, await를 예제와 함께 깊이 있게 살펴봅니다.
tags: [dart, async, tutorial]
readTime: 10
---

# Dart async/await 완벽 이해하기

현대 앱 개발에서 **비동기 프로그래밍**은 필수입니다. 네트워크 요청, 파일 I/O, 데이터베이스 작업은 모두 시간이 걸리는 작업이기 때문입니다. Dart는 `Future`와 `async/await`를 통해 이를 우아하게 처리합니다.

## Future란?

`Future<T>`는 미래에 완료될 값을 나타내는 객체입니다. JavaScript의 `Promise`와 유사합니다.

```dart
Future<String> fetchUserName(int id) async {
  // 실제로는 API 호출을 하겠지만, 여기서는 시뮬레이션
  await Future.delayed(const Duration(seconds: 1));
  return 'User $id';
}
```

## async와 await

`async`는 함수가 비동기임을 선언하고, `await`는 Future가 완료될 때까지 기다립니다.

```dart
void main() async {
  print('시작');

  final name = await fetchUserName(42);
  print('이름: $name'); // 1초 후 출력

  print('끝');
}
```

출력 결과:
```
시작
이름: User 42
끝
```

## 에러 처리

`try/catch`를 사용해 비동기 에러를 처리합니다.

```dart
Future<void> loadData() async {
  try {
    final data = await fetchData();
    processData(data);
  } catch (e) {
    print('에러 발생: $e');
  } finally {
    print('항상 실행됨');
  }
}
```

## Future.wait - 병렬 실행

여러 Future를 동시에 실행하고 모두 완료될 때까지 기다립니다.

```dart
Future<void> loadAllData() async {
  // 순차 실행 (느림) - 3초
  final user = await fetchUser();
  final posts = await fetchPosts();

  // 병렬 실행 (빠름) - 최대 1.5초
  final results = await Future.wait([
    fetchUser(),
    fetchPosts(),
    fetchComments(),
  ]);

  final user2 = results[0];
  final posts2 = results[1];
}
```

## Stream - 연속된 비동기 데이터

`Stream`은 시간에 걸쳐 여러 값을 비동기적으로 받을 때 사용합니다.

```dart
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

// 사용
await for (final count in countDown(5)) {
  print(count); // 5, 4, 3, 2, 1, 0
}
```

## Flutter에서의 활용

Flutter에서는 `FutureBuilder`와 `StreamBuilder` 위젯을 활용합니다.

```dart
FutureBuilder<String>(
  future: fetchUserName(1),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('에러: ${snapshot.error}');
    }
    return Text('안녕하세요, ${snapshot.data}!');
  },
)
```

## 정리

| 개념 | 용도 |
|------|------|
| `Future<T>` | 단일 비동기 값 |
| `async/await` | 비동기 코드를 동기처럼 작성 |
| `Future.wait` | 여러 Future 병렬 실행 |
| `Stream<T>` | 연속적인 비동기 값들 |
| `FutureBuilder` | Flutter에서 Future UI 처리 |

Dart의 비동기 모델을 잘 이해하면 더 빠르고 반응성 좋은 앱을 만들 수 있습니다.
