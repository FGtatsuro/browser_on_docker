#!/usr/bin/env python
# -*- coding: utf-8 -*-

import chromedriver_binary
import pytest
from selenium import webdriver


# FYI:
#   - https://docs.pytest.org/en/latest/fixture.html
@pytest.fixture(scope="module")
def driver():
    # FYI:
    #   - https://selenium-python.readthedocs.io/getting-started.html#using-selenium-with-remote-webdriver
    options = webdriver.ChromeOptions()
    options.headless = True
    driver = webdriver.Remote(
        # TODO: DRY hostname(=browser container name)
        command_executor='http://browser_on_docker_browser:4444/wd/hub',
        desired_capabilities=webdriver.DesiredCapabilities.CHROME,
        options=options
    )
    yield driver
    driver.quit()


# NOTE: It's better to use test libraries supporting declarative syntax.
def should_pythonorg_title_is_Python(driver):
    driver.get("http://www.python.org")
    assert "Python" in driver.title
