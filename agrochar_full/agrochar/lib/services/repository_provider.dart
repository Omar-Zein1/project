import 'repository.dart';
import 'mock_repository.dart';
import 'firebase_repository.dart';

// Toggle this to switch to Firestore after configuring Firebase.
const bool useFirebase = false;

Repository provideRepository() {
  if (useFirebase) {
    return FirebaseRepository();
  } else {
    return MockRepository.seeded();
  }
}
