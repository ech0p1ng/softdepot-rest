class Game {
    constructor(name, preview_img, url, price, tags, score, description, big_description) {
        this.name = name;
        this.preview_img = preview_img;
        this.url = url;
        this.price = price;
        this.tags = tags;
        // this.score = score;
        this.score = Number(((score / 100) * 5).toFixed(1));
        this.game_row = null;
        this.description = description;
        this.big_description = big_description;
        this.in_cart = false;
        this._add_to_cart_button = null;
    }

    //Определение цвета оценки по числу (0 - красный, 5 - зеленый)
    getScoreColor(score) {
        let range = 512;
        let r = 255;
        let g = 0;
        let b = 0;
        let g1 = parseInt((range / 5) * parseFloat(score));
        g += g1;

        if (g > 255) {
            r -= g - 255;
            g = 255;
        }
        r -= 64;
        g -= 64;
        b -= 64;

        return "rgb(" + r + "," + g + "," + b + ")";
    }

    buy() {
        cart_of_games.push(this);
        this.in_cart = true;
        this._add_to_cart_button.innerHTML = "<span>Удалить из корзины</span>";
        this._add_to_cart_button.className = "remove-from-cart";
    }

    // удаление из корзины
    removeFromCart() {
        cart_of_games.splice(cart_of_games.indexOf(this), 1);
        this.in_cart = false;
        this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";
        this._add_to_cart_button.className = "add-to-cart";
    }

    // changeAddToCartButton() {
    //     if (this.in_cart) {
    //         this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";
    //         this._add_to_cart_button.className = "add-to-cart";
    //     } else {
    //         this._add_to_cart_button.innerHTML = "<span>Удалить из корзины</span>";
    //         this._add_to_cart_button.className = "remove-from-cart";
    //     }
    // }

    //Создание строки в каталоге
    getGameRowPreview() {
        this.game_row = document.createElement("div");
        this.game_row.className = "game-row";
        this.game_row.href = this.url;
        this.game_row.style.zIndex = 1;

        let preview = document.createElement("img");
        preview.className = "preview";
        preview.src = this.preview_img;

        let text = document.createElement("div");
        let description = document.createElement("a");
        description.href = this.url;
        description.target = "_blank";
        let name = document.createElement("span");
        let tags = document.createElement("span");
        description.className = "description";
        name.className = "name";
        tags.className = "tags";
        name.innerHTML = this.name;
        tags.innerHTML = this.tags;
        text.append(name);
        text.append(document.createElement("br"));
        text.append(tags);
        description.append(text);

        let score = document.createElement("span");
        score.className = "score";
        score.innerHTML = this.score;
        score.title = "Оценка пользователей";
        score.style.color = this.getScoreColor(this.score);
        description.append(score);

        let price_and_buy = document.createElement("div");
        let price = document.createElement("span");
        this._add_to_cart_button = document.createElement("button");
        price_and_buy.className = "price-and-buy";
        price.className = "price";

        if (this.price > 0) {
            price.innerHTML = "<span>" + this.price + " руб.</span>";
        } else {
            price.innerHTML = "<span>Бесплатно</span>";
        }

        this._add_to_cart_button.className = "add-to-cart";
        this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";

        this._add_to_cart_button.onclick = () => {
            if (cart_of_games.indexOf(this) === -1) {
                this.buy();
            } else {
                this.removeFromCart();
            }
        };
        this._add_to_cart_button.style.zIndex = 2;
        price_and_buy.append(price);
        price_and_buy.append(this._add_to_cart_button);

        this.game_row.append(preview);
        this.game_row.append(description);
        this.game_row.append(price_and_buy);

        this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";

        return this.game_row;
    }

    get_cart_game_row() {
        let cart_game_row = document.createElement("div");
        let cart_game_preview = document.createElement("img");
        let cart_game_description = document.createElement("a");
        let cart_game_title = document.createElement("span");
        let cart_game_price = document.createElement("div");
        let cart_game_price_title = document.createElement("span");
        let cart_game_remove = document.createElement("button");

        cart_game_row.className = "cart-game-row";
        cart_game_preview.className = "preview";
        cart_game_description.className = "cart-game-description";
        cart_game_title.className = "cart-game-title";
        cart_game_price.className = "cart-game-price";
        cart_game_price_title.className = "cart-game-price-title";
        cart_game_remove.className = "cart-game-remove button close-button-bright";

        cart_game_preview.src = this.preview_img;
        cart_game_description.href = this.url;
        cart_game_title.innerHTML = this.name;
        cart_game_price_title.innerHTML = this.price > 0 ? this.price + " руб." : "Бесплатно";
        cart_game_remove.onclick = () => {
            this.removeFromCart();
            show_cart();
        };

        cart_game_description.append(cart_game_title);
        cart_game_price.append(cart_game_price_title, cart_game_remove);
        cart_game_row.append(cart_game_preview, cart_game_description, cart_game_price);

        return cart_game_row;
    }
}
/*
let games_list = [
    new Game(
        "BeamNG.drive",
        "/games/BeamNG_drive/images/header.jpg",
        "/games/BeamNG_drive/index.html",
        465,
        "Гонки, симулятор, вождение, разрушения, реализм",
        97,
        "Основанный на физике мягких объектов автомобильный симулятор, способный практически на всё.",
        "BeamNG.drive — невероятно реалистичный автосимулятор с практически безграничными возможностями. В основе игры лежит система физики мягких объектов, способная правдоподобно моделировать компоненты автомобиля в реальном времени. Благодаря годам кропотливой разработки, исследований и испытаний, BeamNG.drive способен передать весь восторг вождения в реальном мире. "
    ),
    new Game(
        "Insurgency",
        "/games/Insurgency/images/header.jpg",
        "/games/Insurgency/index.html",
        360,
        "Шутер от первого лица, реализм, тактика",
        92,
        "В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source. ",
        "В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source. "
    ),
    new Game(
        "Overwatch® 2",
        "/games/Overwatch_2/images/header.jpg",
        "/games/Overwatch_2/index.html",
        0,
        "Геройский шутер, бесплатная игра, командная",
        17,
        "Overwatch® 2 - бесплатная командная игра в ярком мире будущего с постоянно растущим списком героев. Играйте вместе с друзьями уже сегодня!",
        "Overwatch® 2 - бесплатная командная игра в ярком мире будущего с постоянно растущим списком героев. Играйте вместе с друзьями уже сегодня!"
    ),
    new Game(
        "Unreal Physics",
        "/games/Unreal_Physics/images/header.jpg",
        "/games/Unreal_Physics/index.html",
        0,
        "Казуальная игра, физика, песочница, бесплатная игра",
        66,
        "Unreal Physics — это исследование игровой физики, как никогда раньше. Эта динамичная 3D-песочница включает в себя завораживающую коллекцию демоверсий, демонстрирующих потрясающие визуальные эффекты и реалистичные симуляции. Это игровая площадка безграничных возможностей",
        "Погрузитесь в динамичный мир физики с Unreal Physics — захватывающей песочницей с 3D-физикой и коллекцией демонстраций, которая расширяет границы Unreal Engine. Этот уникальный опыт сочетает в себе передовые физические системы FluidNinja и Chaos, создавая завораживающую демонстрацию динамики жидкости, разрушения и реалистичного моделирования."
    ),
    new Game(
        "Squad",
        "/games/Squad/images/header.jpg",
        "/games/Squad/index.html",
        1099,
        "Боевые действия, реализм, тактика, шутер",
        83,
        "Squad - многопользовательский шутер от первого лица, достоверно воспроизводящий современный общевойсковой бой с участием до 100 человек благодаря масштабным картам, фортификации, использованию военной техники, а также встроенной позиционной голосовой связи.",
        'Squad - это воплощение тактических военных действий. Соревнуйтесь в масштабных сражениях 50 на 50 в самом реалистичном общевойсковом шутере от первого лица. Squad подчеркивает реалистичность боя благодаря командной работе, тактике и аутентичному ведению боя. Широкий выбор реалистичного оружия и транспортных средств, характерных для конкретной фракции, позволяет игрокам создавать собственное снаряжение, которое наилучшим образом соответствует их предпочтительной тактике. А благодаря уникальным оптическим прицелам Squad "Картинка в картинке" вы как будто целитесь во врага через настоящие военные прицелы.<br/>Благодаря 13 фракциям, 24 крупным картам и огромному арсеналу оружия и транспортных средств, Squad создает захватывающий дух, интуитивный шутер, требующий принятия решений за доли секунды в напряженных, реалистичных перестрелках.'
    ),
    new Game(
        "Half-Life 2",
        "/games/Half-Life_2/images/header.jpg",
        "/games/Half-Life_2/index.html",
        385,
        "Шутер от первого лица, экшен, классика",
        97,
        "1998 год. HALF-LIFE шокирует игровую индустрию сочетанием напряженного действия и непрерывного, затягивающего сюжета. Дебютная игра Valve завоевала свыше 50 наград «Игра года» на пути к получению титула «Лучшая игра для РС всех времен» от PC Gamer; она раскрутила франшизу, которая продала свыше восьми миллионов коробочных версий по всему...",
        "1998 год. HALF-LIFE шокирует игровую индустрию сочетанием напряженного действия и непрерывного, затягивающего сюжета. Дебютная игра Valve завоевала свыше 50 наград «Игра года» на пути к получению титула «Лучшая игра для РС всех времен» от PC Gamer; она раскрутила франшизу, которая продала свыше восьми миллионов коробочных версий по всему миру.<br/><br/>СЕЙЧАС. Сохранив атмосферу тревоги, вызова и внутреннего напряжения и добавив новый реализм и интерактивность, Half-Life 2 открывает дверь в мир, в котором присутствие игрока влияет на все, что его окружает — от физической среды до поведения и даже эмоций как друзей, так и врагов.<br/><br/>Игрок вновь поднимает монтировку ученого-исследователя Гордона Фримена, который обнаруживает себя на наводненной чужаками Земле, ресурсы которой стремительно опустошаются, а население вырождается. Фримену навязана неизбежная роль спасителя человечества от того зла, которое он выпустил на свободу в Черной Мезе. И очень многие дорогие ему люди надеются на него.<br/><br/>Напряженный геймплей Half-Life 2 в режиме реального времени стал возможным исключительно благодаря Source®, — новому собственному высокотехнологичному игровому движку от Valve."
    ),
    new Game(
        "Ready or Not",
        "/games/Ready_or_Not/images/header.jpg",
        "/games/Ready_or_Not/index.html",
        1199,
        "Тактика, реализм, шутер от первого лица, бой",
        96,
        "Лос-Суэнос. Полиция Лос-Суэноса сообщает о всплеске преступности в городе. Отряды спецназа направлены для урегулирования таких опасных ситуаций, как захват заложников, угрозы взрыва и перестрелки с подозреваемыми.",
        "Лос-Суэнос. Полиция Лос-Суэноса сообщает о небывалом всплеске преступности в городе. Отряды специального назначения, или спецназа, направлены для урегулирования таких опасных ситуаций, как захват заложников, угрозы взрыва, перестрелки с подозреваемыми, забаррикадировавшимися в зданиях, и не только. Горожан просят соблюдать осторожность при передвижении по городу или оставаться дома.<br/><br/>Несмотря на то что Лос-Суэнос до сих пор обладает репутацией богатого города, с каждым днем значительной части его жителей становится все труднее позволить себе качественные товары. «В городе полно высоток с крошечными квартирами и разваливающихся дешевых домов, чем и пользуются представители криминального подполья, словно паразиты, — говорит начальник полиции Гало Альварес. — Наши люди просто пытаются выжить. В такой непростой обстановке полиция и спецназ остаются силой, которая скрепляет наше общество в единый механизм и не дает ему рассыпаться под натиском преступного хаоса».<br/><br/>В борьбе с процветающей в городе преступностью господин Альварес назначил на должность командира спецназа Дэвида Бомонта, который получил прозвище Судья за решительную приверженность правосудию. Вскоре после этой новости Управление полиции Лос-Суэноса объявило об активном наборе в спецназ новых бойцов с целью вернуть городу долгожданный покой.<br/><br/>Командир Бомонт добавляет: «Эта работа не для слабонервных. Экстремисты, продажные политики, огромные запасы оружия, торговля людьми, наркотиками, изготовление порнографии — навести порядок в Лос-Суэносе будет непросто. Большинство людей, скорее всего, не столкнется ни с чем из перечисленного в обычной жизни. Но тот, кто захочет связать свою жизнь с восстановлением справедливости, должен будет ежедневно взаимодействовать с этой реальностью в границах закона и жить с последствиями своих решений».<br/><br/>Управление полиции Лос-Суэноса официально опубликовало подробности задачи, которая стоит перед командиром Бомонтом и его бойцами:<br/><br/>Новые результаты. Даже если вы уже бывали в Лос-Суэносе, вы должны знать, что за последнее время изменились и сам город, и наши методы и инструменты работы. Городские злачные места, которые вам, возможно, уже знакомы, откроются с новой стороны. Изменились и подходы, которые мы используем при реагировании на звонки. Более того, согласно нашим сведениям, как минимум в четырех новых опасных полицейских округах потребуется провести рискованные тактические операции. Также беспорядки наблюдаются еще в четырех существующих округах, известных высоким уровнем преступности.<br/><br/>Возьмите руководство на себя. Командиру отряда спецназа предстоит набрать из длинного списка кандидатов команду бойцов, каждый из которых обладает уникальными способностями. Как их лидер, вы будете отдавать тактические приказы, тщательно планировать задания и делать все возможное для их успешного выполнения. Командир должен добросовестно подходить к решению каждой задачи, а также следить за здоровьем своих подопечных — как физическим, так и душевным. Нерешенные проблемы ведут к тому, что боец становится не способен выполнять свои обязанности или даже может захотеть уволиться. Выведенные из строя бойцы временно не будут принимать участие в заданиях, а погибшие, естественно, покинут вас навсегда. Командир спецназа тоже не бессмертен: каждый день ему придется принимать важные решения, от последствий которых может зависеть его жизнь.<br/><br/>Усиление состава. Долгожданное усовершенствование процесса тренировки бойцов спецназа, обучение тактике и большой опыт работы привели к улучшению способностей сотрудников. Их численность также увеличилась. Тактическая гибкость позволяет нашим бойцам уверенно справляться с любой сложной ситуацией, совмещая слаженную командную работу и способность действовать самостоятельно. Членам отрядов также доступны дополнительные базовые тренировки для поддержания их знаний, а также отличной физической формы.<br/><br/>Экипировка и кастомизация. Работа в спецназе связана с огромным риском, поэтому в распоряжении бойцов находится самое лучшее оружие и экипировка, включая множество новинок. Но кастомизация доступна не только для снаряжения: совершая подвиги в составе сплоченной команды, вы будете получать новую одежду, рисунки на теле и даже наручные часы. Наконец, мы полностью переделали тренировочный центр, поэтому теперь бойцам будет намного удобнее практиковаться в стрельбе между выездами на задание. "
    ),
    new Game(
        "MudRunner",
        "/games/MudRunner/images/header.jpg",
        "/games/MudRunner/index.html",
        1199,
        "Бездорожье, симулятор, автосимулятор",
        90,
        "MudRunner — это бескомпромиссные гонки по бездорожью, в которых вам предстоит покорять экстремальное сибирское бездорожье за рулем навороченного транспорта повышенной проходимости, имея при себе лишь карту и компас!",
        "MudRunner — это бескомпромиссные гонки по бездорожью, в которых вам предстоит покорять экстремальное сибирское бездорожье за рулем навороченного транспорта повышенной проходимости, имея при себе лишь карту и компас!<br/><br/>У вас будет 19 мощных внедорожников на выбор, у каждого из которых есть свои характеристики и крепящееся оборудование. Выполняйте задания и осуществляйте доставку, преодолевая препятствия и опасные условия в диком экстремальном бездорожье с динамической сменой дня и ночи. Исследуйте реалистичные зоны-песочницы с улучшенной графикой. Проезжайте по грязным дорогам, пересекайте реки и другие препятствия, которые реалистично реагируют на вес и движения вашего внедорожника благодаря продвинутой физике движка игры.<br/><br/>Вооружившись картой, компасом, лебедкой и собственными навыками вождения, отправьтесь в одиночную поездку или присоединитесь к трем другим гонщикам в сетевом кооперативном режиме. Загружайте модификации, созданные активным сообществом MudRunner — вас ждет масса контента, который дополняет постоянно развивающийся мир игры."
    ),
    new Game(
        "Euro Truck Simulator 2",
        "/games/Euro_Truck_Simulator_2/images/header.jpg",
        "/games/Euro_Truck_Simulator_2/index.html",
        1249,
        "Вождение, транспорт, симулятор, реализм",
        97,
        "Станьте королем европейских дорог — водителем грузовика, который доставляет важные грузы на немалые расстояния! Вас ждут десятки городов Великобритании, Бельгии, Германии, Италии, Нидерландов, Польши и не только. Испытайте свои умения, выносливость и скорость.",
        "Станьте королем европейских дорог — водителем грузовика, который доставляет важные грузы на немалые расстояния! Вас ждут десятки городов Великобритании, Бельгии, Германии, Италии, Нидерландов, Польши и не только. Испытайте свои умения, выносливость и скорость. Докажите, что готовы стать частью элитного сообщества дальнобойщиков!"
    ),
    new Game(
        "Spaceflight Simulator",
        "/games/Spaceflight_Simulator/images/header.jpg",
        "/games/Spaceflight_Simulator/index.html",
        199,
        "Песочница, космический симулятор, симулятор",
        96,
        "In Spaceflight Simulator, you will get to build your rockets, plan launches and flights, attempt landings, deploy payloads and explore new worlds.",
        "<b>EXPLORE SPACE</b><br/><br/>Be in command of your own space program, from rocket design to interplanetary travel and achieve your dream of cruising through the cosmos in your custom spacecraft.<br/><br/>In Spaceflight Simulator, you will get to engineer your rockets, plan launches and flights, attempt landings, deploy payloads and explore new worlds.<br/><br/><b>EASY-TO-PICK UP, HARD-TO-MASTER</b><br/><br/>You could be launching your first rocket within minutes, but landing it in one piece might be another story!<br/><br/>With so many parts to pick from, you will learn through trial and error how to build spacecrafts best adapted to each of your missions. You will have to master navigating through the Solar system and landing your vehicle on all the planets and moons, each with their own atmospheric and terrain conditions.<br/><br/><b>REAL-WORD PHYSICS</b><br/><br/>During the design phase, you will get to assemble your own launch vehicle from a wide variety of components and pair them with a multitude of engines, all modeled after their real-world counterparts. Each part possesses its own technical specifications (mass, aerodynamics, etc.) which will affect your rocket's behavior.<br/><br/>All engines accurately model thrust and fuel consumption affecting how much payload you'll be able to carry safely. You'll be able to create multistage vehicles, control how they separate and when secondary burn occurs in order to achieve the optimal trajectory.<br/><br/><b>BUILD YOUR WORLD</b><br/><br/>Fuel your ambitions, launch satellites, build exploration rovers, space stations, multiple rockets into space. Your world is persistent and only your imagination is your limit.<br/><br/>Conquer the harsh conditions of the Solar system, travel long distances and build your presence in space throughout multiple missions.<br/><br/><b>PARTS, PARTS, PARTS</b><br/><br/>Each part is highly detailed and serves a particular purpose. They are all based on their real-world equivalent and allow you to recreate your favorite historical rocket."
    ),
];
*/
