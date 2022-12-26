
/*
dart操作html,类似js
 */
class XHtmlUtils{


  /*

  import 'dart:html';

  / Find an element by id (an-id).
Element idElement = querySelector('#an-id')!;

// Find an element by class (a-class).
Element classElement = querySelector('.a-class')!;

// Find all elements by tag (<div>).
List<Element> divElements = querySelectorAll('div');

// Find all text inputs.
List<Element> textInputElements = querySelectorAll(
  'input[type="text"]',
);

// Find all elements with the CSS class 'class'
// inside of a <p> that is inside an element with
// the ID 'id'.
List<Element> specialParagraphElements = querySelectorAll('#id p.class');

<a id="example" href="/another/example">link text</a>
var anchor = querySelector('#example') as AnchorElement;
anchor.href = 'https://dart.dev';


<p>
  <span class="linux">Words for Linux</span>
  <span class="macos">Words for Mac</span>
  <span class="windows">Words for Windows</span>
</p>
const osList = ['macos', 'windows', 'linux'];
final userOs = determineUserOs();

// For each possible OS...
for (final os in osList) {
  // Matches user OS?
  bool shouldShow = (os == userOs);

  // Find all elements with class=os. For example, if
  // os == 'windows', call querySelectorAll('.windows')
  // to find all elements with the class "windows".
  // Note that '.$os' uses string interpolation.
  for (final elem in querySelectorAll('.$os')) {
    elem.hidden = !shouldShow; // Show or hide.
  }
}


elem.attributes['someAttribute'] = 'someValue';
var elem = ParagraphElement();
elem.text = 'Creating is easy!';

var elem2 = Element.html(
  '<p>Creating <em>is</em> easy!</p>',
);
document.body!.children.add(elem2);

querySelector('#inputs')!.nodes.add(elem);

querySelector('#status')!.replaceWith(elem);

// Find a node by ID, and remove it from the DOM if it is found.
querySelector('#expendable')?.remove();

var elem = querySelector('#message')!;
elem.classes.add('warning');

var message = DivElement();
message.id = 'message2';
message.text = 'Please subscribe to the Dart mailing list.';


var message = DivElement()
  ..id = 'message2'
  ..text = 'Please subscribe to the Dart mailing list.';


 message.style
  ..fontWeight = 'bold'
  ..fontSize = '3em';


  // Find a button by ID and add an event handler.
querySelector('#submitInfo')!.onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});


document.body!.onClick.listen((e) {
  final clickedElem = e.target;
  // ...
});



   */


}
