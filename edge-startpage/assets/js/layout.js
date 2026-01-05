// ┬  ┌─┐┬ ┬┌─┐┬ ┬┌┬┐
// │  ├─┤└┬┘│ ││ │ │
// ┴─┘┴ ┴ ┴ └─┘└─┘ ┴
// Generate Layout.

const generateLayout = () => {
  const firstButtonsContainer = `
    <div class="buttonsContainer" id="buttons_1"></div>
  `;
  const secondButtonsContainer = `
    <div class="buttonsContainer" id="buttons_2"></div>
  `;
  const firstListsContainer = `
    <div class="listsContainer" id="lists_1"></div>
  `;

  const secondListsContainer = `
    <div class="listsContainer" id="lists_2"></div>
  `;

  const position = "beforeend";

  switch (CONFIG.bentoLayout) {
    case "bento":
      linksBlockLeft.insertAdjacentHTML(position, firstButtonsContainer);
      linksBlockRight.insertAdjacentHTML(position, firstListsContainer);
      linksBlock.classList.remove("reduceGap");
      linksBlock.classList.remove("removeGap");
      break;
    case "lists":
      linksBlockLeft.insertAdjacentHTML(position, firstListsContainer);
      linksBlockRight.insertAdjacentHTML(position, secondListsContainer);
      linksBlock.classList.add("reduceGap");
      break;
    case "buttons":
      linksBlockLeft.insertAdjacentHTML(position, firstButtonsContainer);
      linksBlockRight.insertAdjacentHTML(position, secondButtonsContainer);
      linksBlock.classList.add("removeGap");
      break;
    default:
      break;
  }
};

generateLayout();
