import 'package:flutter/material.dart';
import '../models/program_item_model.dart';

class ProgramController extends ValueNotifier<int> {
  ProgramController() : super(0);

  String announcements = 'Insert Sabbath and mid-week announcements here.';
  String selectedLanguage = 'Tagalog';

  void setLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }

  List<ProgramItem> programList = [
    // --- SABBATH SCHOOL ---
    ProgramItem(
      id: 'ss_1',
      section: 'Sabbath School',
      title: 'Chorister Song Lead [Hymnal]',
      person: 'Person 1',
      event: 'nakaupo kantahan',
      isHymn: true,
    ),
    ProgramItem(
      id: 'ss_2',
      section: 'Sabbath School',
      title: 'Opening Prayer',
      person: 'Person 2',
      event: 'nakatayo pray',
    ),
    ProgramItem(
      id: 'ss_3',
      section: 'Sabbath School',
      title: 'Presider',
      person: 'Sis. Kierstiene Faith Sore',
      event: 'upo uli',
    ),
    ProgramItem(
      id: 'ss_4',
      section: 'Sabbath School',
      title: 'Musical Offering',
      person: 'College Students',
    ),
    ProgramItem(
      id: 'ss_5',
      section: 'Sabbath School',
      title: 'Testimonies',
      person: 'Anyone',
    ),
    ProgramItem(
      id: 'ss_6',
      section: 'Sabbath School',
      title: 'Mission Spotlight',
      person: 'Person 3',
    ),
    ProgramItem(
      id: 'ss_7',
      section: 'Sabbath School',
      title: 'Musical Offering',
      person: 'Womens',
    ),
    ProgramItem(
      id: 'ss_8',
      section: 'Sabbath School',
      title: 'Lesson Review',
      person: 'Person 4',
    ),
    ProgramItem(
      id: 'ss_9',
      section: 'Sabbath School',
      title: 'Closing Song: Paaralang Sabado [VP]',
      person: '',
      hasVP: true,
    ),
    ProgramItem(
      id: 'ss_10',
      section: 'Sabbath School',
      title: 'Closing Prayer',
      person: 'Person 5',
    ),
    // ENTRY NO. 11: ANNOUNCEMENTS RIGHT AFTER SABBATH SCHOOL
    ProgramItem(
      id: 'ss_11',
      section: 'Sabbath School',
      title: 'Announcements',
      person: 'Church Clerk / Elder',
    ),

    // --- DIVINE WORSHIP ---
    ProgramItem(
      id: 'dw_1',
      section: 'Divine Worship',
      title: 'Chorister [Hymnal]',
      person: 'Person 1.1',
      event: 'upo lang',
      isHymn: true,
    ),
    ProgramItem(
      id: 'dw_2',
      section: 'Divine Worship',
      title: 'Sing: Holy Holy Holy [VP]',
      person: '',
      event: 'Luhod',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_3',
      section: 'Divine Worship',
      title: 'Sing: We Love Thy Sabbath Lord [VP]',
      person: '',
      event: 'Tayo naman',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_4',
      section: 'Divine Worship',
      title: 'Prayer of Speaker',
      person: 'Person 1.5',
    ),
    ProgramItem(
      id: 'dw_5',
      section: 'Divine Worship',
      title: 'Tithes and Offering Reading',
      person: 'Person 1.2',
      event: 'upo uli',
    ),
    ProgramItem(
      id: 'dw_6',
      section: 'Divine Worship',
      title: 'Chorister: There Shall Be Showers of Blessing [VP]',
      person: '',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_7',
      section: 'Divine Worship',
      title: 'Praise God From Whom All Blessings Flow [VP]',
      person: '',
      event: 'after malikom tatayo',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_8',
      section: 'Divine Worship',
      title: 'Pray for the Offering',
      person: 'Person 1.2',
    ),
    ProgramItem(
      id: 'dw_9',
      section: 'Divine Worship',
      title: 'Opening Song [Hymnal]',
      person: 'Chorister',
      isHymn: true,
    ),
    ProgramItem(
      id: 'dw_10',
      section: 'Divine Worship',
      title: 'Key Text Reading',
      person: 'Person 1.3',
    ),
    ProgramItem(
      id: 'dw_11',
      section: 'Divine Worship',
      title: 'Where Jesus Pleads [VP]',
      person: '',
      event: 'Luhod naman',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_12',
      section: 'Divine Worship',
      title: 'Pastoral Prayer',
      person: 'Person 1.3',
    ),
    ProgramItem(
      id: 'dw_13',
      section: 'Divine Worship',
      title: 'O Thou Who Hearest [VP]',
      person: '',
      hasVP: true,
    ),
    ProgramItem(
      id: 'dw_14',
      section: 'Divine Worship',
      title: 'Special Song',
      person: 'Fathers',
      event: 'tayo na balik sa upuan tapos upo',
    ),
    ProgramItem(
      id: 'dw_15',
      section: 'Divine Worship',
      title: 'Introduction to Speaker (Optional)',
      person: 'Person 1.4',
    ),
    ProgramItem(
      id: 'dw_16',
      section: 'Divine Worship',
      title: 'Sermon / Speaker',
      person: 'Person 1.5',
    ),
    ProgramItem(
      id: 'dw_17',
      section: 'Divine Worship',
      title: 'Special Song (Optional)',
      person: 'High School Students',
    ),
    ProgramItem(
      id: 'dw_18',
      section: 'Divine Worship',
      title: 'Closing Prayer',
      person: 'Person 1.5',
      event: 'Tayo na',
    ),
    ProgramItem(
      id: 'dw_19',
      section: 'Divine Worship',
      title: 'Closing Song: Signs of the End [VP]',
      person: '',
      hasVP: true,
    ),
  ];

  int get currentIndex => value;

  void nextStep() {
    if (value < programList.length - 1) {
      value++;
    }
  }

  void previousStep() {
    if (value > 0) {
      value--;
    }
  }

  void selectStep(int index) {
    if (index >= 0 && index < programList.length) {
      value = index;
    }
  }

  void saveSettings(List<ProgramItem> updatedList, String newAnnouncements) {
    programList = updatedList;
    announcements = newAnnouncements;
    notifyListeners();
  }
}