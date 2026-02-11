# Campus Library Borrowing Tracker

A comprehensive iOS library management system built with SwiftUI and Core Data. This app allows librarians to manage books, members, and track borrowing activities.

## 📱 Features

- **Book Management**: Add, edit, delete, and search books by title or author
- **Category Filtering**: Organize books into categories (Fiction, Non-Fiction, etc.)
- **Member Management**: Track library members with contact information
- **Loan System**: Borrow and return books with due date tracking
- **Overdue Detection**: Automatic highlighting of overdue loans
- **Availability Status**: Real-time book availability updates

## 🛠️ Technologies Used

- **SwiftUI** - Modern declarative UI framework
- **Core Data** - Local persistent storage
- **iOS 16.0+** - Target deployment
- **Xcode 14** - Development environment

## 📊 Core Data Model

### Entities

**Category**
- `id`: UUID
- `name`: String

**Book**
- `id`: UUID
- `title`: String
- `author`: String
- `isbn`: String (optional)
- `addedAt`: Date
- `isAvailable`: Bool

**Member**
- `id`: UUID
- `name`: String
- `email`: String
- `joinedAt`: Date

**Loan**
- `id`: UUID
- `borrowedAt`: Date
- `dueAt`: Date
- `returnedAt`: Date (optional)
- `status`: String (optional)

### Relationships

- **Category → Book**: One-to-Many (Delete Rule: Nullify)
- **Book → Loan**: One-to-Many (Delete Rule: Cascade)
- **Member → Loan**: One-to-Many (Delete Rule: Cascade)


## 📸 Screenshots

<div align="center">

### Books View
<img src="screenshots/books_view.png" width="300">

### Members Management
<img src="screenshots/members_view.png" width="300">

### Member Details
<img src="screenshots/member_detailsview.png" width="300">

### Borrow Book
<img src="screenshots/borrow_view.png" width="300">

### Loans Tracking
<img src="screenshots/loans_view.png" width="300">

### Edit Member
<img src="screenshots/edit_member_view.png" width="300">

### Add Member
<img src="screenshots/add_memberview.png" width="300">

</div>
## 🏗️ Architecture

### Design Pattern: MVVM + Repository

- **Views**: SwiftUI views for UI presentation
- **LibraryHolder**: ObservableObject managing all business logic
- **Core Data**: Repository pattern for data persistence

### Key Components

**LibraryHolder** (`LibraryHolder.swift`)
- Centralized business logic
- All CRUD operations
- Borrow/return functionality
- Search and filtering logic

**Views** (`Views/`)
- `BooksView`: Book browsing and management
- `MembersView`: Member list and management
- `LoansView`: Loan tracking with status
- `EditBookView`, `AddBookView`: Book CRUD
- `EditMemberView`, `AddMemberView`: Member CRUD
- `BorrowBookView`: Borrow flow
- `MemberDetailView`: Member details with loan history

## Business Rules

1. **Borrowing**:
   - Creates a Loan record
   - Sets `Book.isAvailable = false`
   - Due date calculated from borrow date + selected days (7-30)

2. **Returning**:
   - Sets `Loan.returnedAt = Date()`
   - Sets `Book.isAvailable = true`

3. **Validation**:
   - Cannot borrow unavailable books
   - Members require name and email
   - Books require title

4. **Cascading Deletes**:
   - Deleting a member returns all borrowed books
   - Deleting a book removes associated loans
   - Deleting a category keeps books (nullifies relationship)

## Testing

### Manual Test Scenarios

1. **Add a Book**
   - Go to Books tab → Tap +
   - Fill in title, author, ISBN
   - Select category → Create

2. **Borrow a Book**
   - Go to Members tab → Select member
   - Tap "Borrow a Book"
   - Select available book → Set due date → Borrow

3. **Return a Book**
   - Go to Loans tab
   - Find active loan → Tap "Return Book"

4. **Test Overdue**
   - Borrow a book with 7 days due
   - Check Loans tab after 7 days (or modify due date in database)

##  Contributing

This is a school project for IOS 2 - Mid Term Assessment 4.


**Course**: iOS Development 2
**Instructor**: Jerry Joy
**Institution**: LaSalle College Montreal

## 📄 License

This project is created for educational purposes.



